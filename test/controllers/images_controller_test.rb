require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  def test_index
    images = [
      Image.create(url: 'https://google.com', created_at: 3.minutes.ago, tag_list: 'google'),
      Image.create(url: 'https://facebook.com', created_at: 2.minutes.ago, tag_list: 'facebook, evil')
    ]

    get root_path
    assert_response :ok

    assert_select '.js-image' do |elements|
      displayed_image_urls = elements.map { |element| element.attr('src') }
      assert_equal displayed_image_urls, images.reverse.map(&:url)
    end

    assert_select '.js-tag-not-exist', 0
  end

  def test_index__image_should_link_to_show
    image = Image.create(url: 'https://google.com')

    get root_path
    assert_response :ok

    assert_select "a[href='/images/#{image.id}'] > img[src='https://google.com']"
  end

  def test_index__tag_list
    images = [
      Image.create(url: 'https://google.com', created_at: 3.minutes.ago, tag_list: 'google'),
      Image.create(url: 'https://facebook.com', created_at: 2.minutes.ago, tag_list: 'facebook, evil')
    ]

    get root_path
    assert_response :ok

    assert_select '.js-tag-list a' do |elements|
      displayed_image_tag_list = elements.map { |element| element.inner_text.strip }
      assert_equal images.reverse.map(&:tag_list).flatten, displayed_image_tag_list
      displayed_image_tag_list_hrefs = elements.map { |element| element.attr('href').split('=')[1] }
      assert_equal %w[facebook evil google], displayed_image_tag_list_hrefs
    end
  end

  def test_index__filter_by_tag
    Image.create(url: 'https://google.com', tag_list: 'website, google')
    Image.create(url: 'https://example.com', tag_list: 'funny')
    Image.create(url: 'https://facebook.com', tag_list: 'facebook, website')

    get root_path(tag: 'website')
    assert_response :ok

    assert_select '.js-image', 2
    assert_select '.js-tag-not-exist', 0
  end

  def test_index__tag_not_exist
    Image.create(url: 'https://google.com', tag_list: 'website, google')
    Image.create(url: 'https://facebook.com', tag_list: 'facebook, website')

    get root_path(tag: '1234')
    assert_response :ok

    assert_select '.js-image', 0
    assert_includes response.body, 'There is no image under this tag'
  end

  def test_index__wo_image
    get root_path
    assert_response :ok
    assert_select '.js-image', 0
  end

  def test_new
    get new_image_path
    assert_response :ok

    assert_select '.image_url'
    assert_select '#image_tag_list'
  end

  def test_create
    post images_path, params: { image: { url: 'https://www.google.com', tag_list: 'google, search' } }
    assert_redirected_to image_path(Image.last)

    assert_equal 'Image successfully created', flash[:success]
    assert_equal 'https://www.google.com', Image.last.url
    assert_equal %w[google search], Image.last.tag_list
  end

  def test_create__no_tag
    post images_path, params: { image: { url: 'https://www.google.com', tag_list: '' } }
    assert_redirected_to image_path(Image.last)

    assert_equal 'Image successfully created', flash[:success]
    assert_equal 'https://www.google.com', Image.last.url
    assert_equal [], Image.last.tag_list
  end

  def test_create__invalid
    assert_no_difference('Image.count') do
      post images_path, params: { image: { url: '12345' } }
    end

    assert_response :unprocessable_entity
    assert_select '.error', 'is invalid url'
  end

  def test_show
    image = Image.create(url: 'https://google.com', tag_list: 'google, search')
    get image_path(image.id)
    assert_response :ok

    assert_select '.js-image' do |element|
      displayed_image_url = element.attr('src').value
      assert_equal displayed_image_url, image.url
    end

    assert_select '.js-tag-list a' do |elements|
      displayed_image_tag_list = elements.map { |element| element.inner_text.strip }
      assert_equal %w[google search], displayed_image_tag_list
      displayed_image_tag_list_hrefs = elements.map { |element| element.attr('href').split('=')[1] }
      assert_equal %w[google search], displayed_image_tag_list_hrefs
    end
  end

  def test_show__delete_image
    image = Image.create(url: 'https://google.com')
    get image_path(image.id)
    assert_response :ok

    assert_select '.js-delete-image' do |element|
      assert_equal 'Are you sure you want to delete the image?',
                   element.attr('data-confirm').value
    end
  end

  def test_destroy
    image = Image.create(url: 'https://google.com')
    assert_difference('Image.count', -1) do
      delete image_path(image)
    end

    assert_redirected_to images_path
    assert_equal 'Image successfully deleted', flash[:success]
  end

  def test_destroy__already_deleted_image
    assert_difference('Image.count', 0) do
      delete image_path(99)
    end

    assert_redirected_to images_path
    assert_equal 'Image successfully deleted', flash[:success]
  end
end

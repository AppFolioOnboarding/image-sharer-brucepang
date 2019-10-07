require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  def test_index
    images = [
      Image.create(url: 'https://google.com', created_at: 3.minutes.ago),
      Image.create(url: 'https://facebook.com', created_at: 2.minutes.ago)
    ]

    get root_path
    assert_response :ok

    assert_select '.image' do |elements|
      displayed_image_urls = elements.map { |element| element.attr('src') }
      assert_equal displayed_image_urls, images.reverse.map(&:url)
    end
  end

  def test_index__wo_image
    get root_path
    assert_response :ok
    assert_select '.image', 0
  end

  def test_new
    get new_image_path
    assert_response :ok

    assert_select '.image_url'
  end

  def test_create
    post images_path, params: { image: { url: 'https://www.google.com' } }
    assert_redirected_to image_path(Image.last)

    assert_equal 'Image successfully created', flash[:notice]
    assert_equal 'https://www.google.com', Image.last.url
  end

  def test_create__invalid
    assert_no_difference('Image.count') do
      post images_path, params: { image: { url: '12345' } }
    end

    assert_response :unprocessable_entity
    assert_select '.error', 'is invalid url'
  end
end

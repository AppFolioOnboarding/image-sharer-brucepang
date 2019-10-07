require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  def test_valid_url
    image = Image.new(url: 'https://www.google.com')
    assert image.valid?
  end

  def test_invalid_url
    image = Image.new(url: '12345')
    refute image.valid?, 'image is valid with bad url'
    assert_equal ['is invalid url'], image.errors[:url]
  end

  def test_tags
    image = Image.new(url: 'https://www.google.com', tag_list: 'google, search')
    assert_equal %w[google search], image.tag_list
  end

  def test_no_tag
    image = Image.new(url: 'https://www.google.com', tag_list: '')
    assert_equal [], image.tag_list
  end
end

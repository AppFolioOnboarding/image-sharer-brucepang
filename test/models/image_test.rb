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
end

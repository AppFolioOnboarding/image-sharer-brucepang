require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  def test_index
    get root_path
    assert_response :success
  end
end

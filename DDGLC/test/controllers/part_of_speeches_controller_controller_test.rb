require 'test_helper'

class PartOfSpeechesControllerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get part_of_speeches_controller_index_url
    assert_response :success
  end

end

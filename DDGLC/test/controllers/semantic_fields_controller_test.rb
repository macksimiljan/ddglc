require 'test_helper'

class SemanticFieldsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get semantic_fields_index_url
    assert_response :success
  end

end

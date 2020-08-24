require 'test_helper'

class PokerHelpControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get poker_help_index_url
    assert_response :success
  end

end

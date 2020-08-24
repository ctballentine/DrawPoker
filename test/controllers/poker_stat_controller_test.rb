require 'test_helper'

class PokerStatControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get poker_stat_index_url
    assert_response :success
  end

end

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  test 'login with valid information' do
    get login_path
    post login_path, params: { session: { code:    'JoDo',
                                          password: ENV['DUMMY_PW']} }
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert.alert-success.fade.in'
  end
end
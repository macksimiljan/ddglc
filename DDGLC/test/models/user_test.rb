require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(code: 'JoDo', first_name: 'John', last_name: 'Doe',
                     email: 'john.doe@example.com', role: 'admin',
                     password: 'foobar', password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'code and role should be present and valid' do
    @user.code = ' '
    assert_not @user.valid?

    @user.code = 'Jonny'
    assert_not @user.valid?

    @user.code = 'Doe'
    assert_not @user.valid?

    @user.code = 'JoDo'
    duplicate_user = @user.dup
    duplicate_user.code = @user.code.upcase
    @user.save
    assert_not duplicate_user.valid?

    @user.role = nil
    assert_not @user.valid?
  end

  test 'valid email addresses should be accepted' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'invalid email addresses should be rejected' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'password should be present and valid' do
    @user.password = 'foo'
    @user.password_confirmation = 'foo'
    assert_not @user.valid?

    @user.password = 'foobar'
    @user.password_confirmation = 'fobar'
    assert_not @user.valid?

    @user.password = '1a2b3c4d5e6f7g8h'
    @user.password_confirmation = '1a2b3c4d5e6f7g8h'
    assert_not @user.valid?
  end
end

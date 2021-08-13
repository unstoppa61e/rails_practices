require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    # User.count の値が変わらないことを確認
    assert_no_difference 'User.count' do
      # POST メソッド
      post users_path, params: {
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      }
    end
    # 送信に失敗したときにnewアクションが再描画されるはずなので、
    # そのテストも含めている。
    assert_template 'users/new'

    # なぜかこいつだけ反応しない
    assert_select 'a#logo'
    assert_select 'div.col-md-6'
    assert_select 'div.col-md-offset-3'
    assert_select 'div.container'
    assert_select 'div.row'
    assert_select 'footer.footer'
    assert_select 'header.navbar'
    assert_select 'header.navbar-fixed-top'
    assert_select 'header.navbar-inverse'
    assert_select 'input.btn'
    assert_select 'input.btn-primary'
    assert_select 'input.form-control'
    assert_select 'input#user_email'
    assert_select 'input#user_name'
    assert_select 'input#user_password'
    assert_select 'input#user_password_confirmation'
    assert_select 'ul.nav'
    assert_select 'ul.navbar-nav'
    assert_select 'ul.navbar-right'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password"
      }}
    end
    # redirect_to @user の表示を追うため
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:SKT)
	end
    test "login with valiad information" do 
	  	get login_path
	  	post login_path, params: {session: {email: @user.email, password: 'password'} }
        assert_redirected_to @user
        follow_redirect!
        asseert_template 'users/show'
        assert_select "a[href=?]", login_path, count: 0
        assert_select "a[href=?]", logout_path
        assert_select "a[href=?]", user_path(@user)
    end  

    test "login with valid information followed by logout" do 
    	get login_path
    	post login_path, params: {session: {email: @user.email,
    		                                password: 'password'}}
    	assert is_logged_in?
    	assert_redirected_to @user
    	follow_redirect!
    	assert_select "a[href=?]", login_path, count: 0
    	assert_select "a[href=?]", logout_path
    	assert_select "a[href=?]", user_path(@user)
    	delete logout_path
    	assert_not is is_logged_in
    	assert_redirected_to root_url 
    	assert_select "a[href=?]", login_path
    	assert_select "a[href=?]", logout_path, count: 0
    	assert_select "a[href=?]", user_path(u@user), count: 0
    end 
end

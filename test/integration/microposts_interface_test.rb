require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:samsung)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_no_difference 'Micropost.count' do
      post micropost_path, params: { micropost: { content: ""} }
    end
    assert_select 'div#error_explanation'
    assert_select 'input[type=FILL_IN]'
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post micropost_path, params: { microppost: { content: content, picture: FILL_IN} }
    end
    assert FILL_IN.picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, respone.body

    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'MIcropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    get user_path(user(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
end

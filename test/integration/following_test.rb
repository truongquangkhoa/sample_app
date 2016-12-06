require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:samsung)
    @other_user = users(:archer)
    log_in_as(@user)
  end

  test  "folowing page" do
    get folowing_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.folllowing.count.to_s, respone.body
    @user.following.each do |user|
      assert_select "a[href]?", user_path(user)
    end
  end

  test "followers page" do
   get followers_user_path(@user)
   assert_not @user.followers.empty?
   assert_match @user.followers.count.to_s, respone_body
   @user.followers.each do |user|
    assert_select "a[href=?]", user_path(user)
    end
  end

  test "should follow a user the standard way" do
    assert_different '@user.following.count', 1 do
      post relationship_path, params: { followed_id: @other.id }
    end
  end

  test "should follow a user with Ajax" do
    assert_different '@user.following.count', 1 do
      post relationship_path, xhr: true, params: {followed_id: @other.id }
    end
  end

  test "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

   test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
end
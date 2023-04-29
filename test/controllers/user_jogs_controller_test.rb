require "test_helper"

class UserJogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_jog = user_jogs(:one)
  end

  test "should get index" do
    get user_jogs_url
    assert_response :success
  end

  test "should get new" do
    get new_user_jog_url
    assert_response :success
  end

  test "should create user_jog" do
    assert_difference("UserJog.count") do
      post user_jogs_url, params: { user_jog: { : @user_jog., created_by: @user_jog.created_by, deleted: @user_jog.deleted, deleted_at: @user_jog.deleted_at, deleted_by: @user_jog.deleted_by, distance: @user_jog.distance, jogging_date: @user_jog.jogging_date, jogging_time: @user_jog.jogging_time, user_id: @user_jog.user_id } }
    end

    assert_redirected_to user_jog_url(UserJog.last)
  end

  test "should show user_jog" do
    get user_jog_url(@user_jog)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_jog_url(@user_jog)
    assert_response :success
  end

  test "should update user_jog" do
    patch user_jog_url(@user_jog), params: { user_jog: { : @user_jog., created_by: @user_jog.created_by, deleted: @user_jog.deleted, deleted_at: @user_jog.deleted_at, deleted_by: @user_jog.deleted_by, distance: @user_jog.distance, jogging_date: @user_jog.jogging_date, jogging_time: @user_jog.jogging_time, user_id: @user_jog.user_id } }
    assert_redirected_to user_jog_url(@user_jog)
  end

  test "should destroy user_jog" do
    assert_difference("UserJog.count", -1) do
      delete user_jog_url(@user_jog)
    end

    assert_redirected_to user_jogs_url
  end
end

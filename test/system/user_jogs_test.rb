require "application_system_test_case"

class UserJogsTest < ApplicationSystemTestCase
  setup do
    @user_jog = user_jogs(:one)
  end

  test "visiting the index" do
    visit user_jogs_url
    assert_selector "h1", text: "User jogs"
  end

  test "should create user jog" do
    visit user_jogs_url
    click_on "New user jog"

    fill_in "", with: @user_jog.
    fill_in "Created by", with: @user_jog.created_by
    check "Deleted" if @user_jog.deleted
    fill_in "Deleted at", with: @user_jog.deleted_at
    fill_in "Deleted by", with: @user_jog.deleted_by
    fill_in "Distance", with: @user_jog.distance
    fill_in "Jogging date", with: @user_jog.jogging_date
    fill_in "Jogging time", with: @user_jog.jogging_time
    fill_in "User", with: @user_jog.user_id
    click_on "Create User jog"

    assert_text "User jog was successfully created"
    click_on "Back"
  end

  test "should update User jog" do
    visit user_jog_url(@user_jog)
    click_on "Edit this user jog", match: :first

    fill_in "", with: @user_jog.
    fill_in "Created by", with: @user_jog.created_by
    check "Deleted" if @user_jog.deleted
    fill_in "Deleted at", with: @user_jog.deleted_at
    fill_in "Deleted by", with: @user_jog.deleted_by
    fill_in "Distance", with: @user_jog.distance
    fill_in "Jogging date", with: @user_jog.jogging_date
    fill_in "Jogging time", with: @user_jog.jogging_time
    fill_in "User", with: @user_jog.user_id
    click_on "Update User jog"

    assert_text "User jog was successfully updated"
    click_on "Back"
  end

  test "should destroy User jog" do
    visit user_jog_url(@user_jog)
    click_on "Destroy this user jog", match: :first

    assert_text "User jog was successfully destroyed"
  end
end

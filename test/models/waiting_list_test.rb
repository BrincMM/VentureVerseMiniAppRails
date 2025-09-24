require "test_helper"

class WaitingListTest < ActiveSupport::TestCase
  test "should be valid with valid email and subscribe_type" do
    waiting_list = WaitingList.new(email: "test@example.com", subscribe_type: "email")
    assert waiting_list.valid?
  end

  test "should be valid with google subscribe_type" do
    waiting_list = WaitingList.new(email: "test@example.com", subscribe_type: "google")
    assert waiting_list.valid?
  end

  test "should not be valid without email" do
    waiting_list = WaitingList.new(subscribe_type: "email")
    assert_not waiting_list.valid?
    assert_includes waiting_list.errors[:email], "can't be blank"
  end

  test "should not be valid with invalid email format" do
    waiting_list = WaitingList.new(email: "invalid_email", subscribe_type: "email")
    assert_not waiting_list.valid?
    assert_includes waiting_list.errors[:email], "is invalid"
  end

  test "should not allow duplicate emails" do
    WaitingList.create!(email: "test@example.com", subscribe_type: "email")
    waiting_list = WaitingList.new(email: "test@example.com", subscribe_type: "google")
    assert_not waiting_list.valid?
    assert_includes waiting_list.errors[:email], "has already been taken"
  end

  test "should have default subscribe_type as email" do
    waiting_list = WaitingList.new(email: "test@example.com")
    assert waiting_list.valid?
    assert_equal "email", waiting_list.subscribe_type
  end

  test "should scope by email" do
    waiting_list = waiting_lists(:waiting_list_one)
    result = WaitingList.by_email(waiting_list.email)
    assert_includes result, waiting_list
  end

  test "should scope by subscribe_type" do
    email_subscriptions = WaitingList.by_subscribe_type(:email)
    google_subscriptions = WaitingList.by_subscribe_type(:google)
    
    assert_includes email_subscriptions, waiting_lists(:waiting_list_one)
    assert_includes google_subscriptions, waiting_lists(:waiting_list_two)
    assert_not_includes email_subscriptions, waiting_lists(:waiting_list_two)
    assert_not_includes google_subscriptions, waiting_lists(:waiting_list_one)
  end

  test "should order by recent" do
    # Clear existing records to avoid interference
    WaitingList.delete_all
    
    # Create two records with different timestamps
    older = WaitingList.create!(email: "older@example.com", subscribe_type: "email")
    newer = WaitingList.create!(email: "newer@example.com", subscribe_type: "google")
    
    # Update timestamps to ensure order
    older.update_column(:created_at, 2.days.ago)
    newer.update_column(:created_at, 1.day.ago)
    
    recent_list = WaitingList.recent
    assert_equal newer.id, recent_list.first.id
    assert_equal older.id, recent_list.second.id
  end

  test "should split three-word name into first_name and last_name" do
    wl = WaitingList.new(
      email: "threewords@example.com",
      subscribe_type: "email",
      name: "Alice Bob Carol"
    )

    assert wl.valid?, "waiting list should be valid"
    assert_equal "Alice Bob", wl.first_name
    assert_equal "Carol", wl.last_name
  end
end

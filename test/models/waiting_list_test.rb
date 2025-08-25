require "test_helper"

class WaitingListTest < ActiveSupport::TestCase
  test "should be valid with valid email" do
    waiting_list = WaitingList.new(email: "test@example.com")
    assert waiting_list.valid?
  end

  test "should not be valid without email" do
    waiting_list = WaitingList.new
    assert_not waiting_list.valid?
    assert_includes waiting_list.errors[:email], "can't be blank"
  end

  test "should not be valid with invalid email format" do
    waiting_list = WaitingList.new(email: "invalid_email")
    assert_not waiting_list.valid?
    assert_includes waiting_list.errors[:email], "is invalid"
  end

  test "should not allow duplicate emails" do
    WaitingList.create!(email: "test@example.com")
    waiting_list = WaitingList.new(email: "test@example.com")
    assert_not waiting_list.valid?
    assert_includes waiting_list.errors[:email], "has already been taken"
  end

  test "should scope by email" do
    waiting_list = waiting_lists(:waiting_list_one)
    result = WaitingList.by_email(waiting_list.email)
    assert_includes result, waiting_list
  end

  test "should order by recent" do
    # Clear existing records to avoid interference
    WaitingList.delete_all
    
    # Create two records with different timestamps
    older = WaitingList.create!(email: "older@example.com")
    newer = WaitingList.create!(email: "newer@example.com")
    
    # Update timestamps to ensure order
    older.update_column(:created_at, 2.days.ago)
    newer.update_column(:created_at, 1.day.ago)
    
    recent_list = WaitingList.recent
    assert_equal newer.id, recent_list.first.id
    assert_equal older.id, recent_list.second.id
  end
end

require "test_helper"

class DeveloperTest < ActiveSupport::TestCase
  test "should have valid fixtures" do
    assert developers(:one).valid?
    assert developers(:two).valid?
  end

  test "should require email" do
    developer = Developer.new(
      name: "Test Dev",
      password: "password123"
    )
    assert_not developer.valid?
    assert_includes developer.errors[:email], "can't be blank"
  end

  test "should require unique email" do
    developer = Developer.new(
      name: "Test Dev",
      email: developers(:one).email,
      password: "password123"
    )
    assert_not developer.valid?
    assert_includes developer.errors[:email], "has already been taken"
  end

  test "should require unique github" do
    developer = Developer.new(
      name: "Test Dev",
      email: "unique@example.com",
      github: developers(:one).github,
      password: "password123"
    )
    assert_not developer.valid?
    assert_includes developer.errors[:github], "has already been taken"
  end

  test "should have default status pending" do
    developer = Developer.new(
      name: "Test Dev",
      email: "test@example.com",
      password: "password123"
    )
    assert_equal "pending", developer.status
  end

  test "should have default role developer" do
    developer = Developer.new(
      name: "Test Dev",
      email: "test@example.com",
      password: "password123"
    )
    assert_equal "developer", developer.role
  end

  test "should have status enum" do
    developer = developers(:one)
    assert developer.active?
    
    developer.pending!
    assert developer.pending?
    
    developer.suspended!
    assert developer.suspended?
  end

  test "should have helper methods" do
    developer = developers(:one)
    developer.active!
    assert developer.active?
    assert_not developer.suspended?
    assert_not developer.pending?
  end

  test "should have many apps" do
    developer = developers(:one)
    assert_respond_to developer, :apps
  end
end

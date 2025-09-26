require "test_helper"

class PerkAccessTest < ActiveSupport::TestCase
  test "should enforce uniqueness on user and perk" do
    user = users(:user_one)
    perk = perks(:perk_two)

    assert_difference("PerkAccess.count", 1) do
      PerkAccess.create!(user: user, perk: perk)
    end

    duplicate = PerkAccess.new(user: user, perk: perk)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:user_id], "already has access to this perk"
  end

  test "should destroy perk_accesses when perk is destroyed" do
    perk_access = perk_accesses(:perk_access_one)
    perk = perk_access.perk

    assert_difference("PerkAccess.count", -1) do
      perk.destroy
    end

    assert_not PerkAccess.exists?(perk_access.id)
  end

  test "should destroy perk_accesses when user is destroyed" do
    perk_access = perk_accesses(:perk_access_two)
    user = perk_access.user

    assert_difference("PerkAccess.count", -1) do
      user.destroy
    end

    assert_not PerkAccess.exists?(perk_access.id)
  end
end

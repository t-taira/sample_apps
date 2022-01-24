require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

  test "recent_followers within 5 minutes are counted" do
    Relationship.destroy_all
    @relationship.save

    Relationship.create!(
      follower_id: users(:lana).id,
      followed_id: users(:archer).id
    )
    Relationship.create!(
      follower_id: users(:archer).id,
      followed_id: users(:lana).id
    )

    assert_equal 2, Relationship.recent_followers(users(:archer), 5.minutes).size
    assert_equal 1, Relationship.recent_followers(users(:lana), 5.minutes).size
  end

  test "recent_followers after 5 minutes are not counted" do
    Relationship.destroy_all
    @relationship.save

    Relationship.create!(
      follower_id: users(:lana).id,
      followed_id: users(:archer).id,
      created_at: Time.current - 5.minutes
    )
    Relationship.create!(
      follower_id: users(:archer).id,
      followed_id: users(:lana).id,
      created_at: Time.current - 5.minutes
    )

    assert_equal 1, Relationship.recent_followers(users(:archer), 5.minutes).size
    assert_equal 0, Relationship.recent_followers(users(:lana), 5.minutes).size
  end
end

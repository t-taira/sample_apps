class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  def self.recent_followers(followed_id, within_time)
    relations = where(followed_id: followed_id).order(created_at: :desc)
    relations.select do |relation|
      relation.created_at >= (Time.current - within_time)
    end.map(&:follower)
  end
end

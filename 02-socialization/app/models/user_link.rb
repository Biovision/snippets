class UserLink < ApplicationRecord
  include Toggleable

  PER_PAGE = 10

  toggleable :visible

  belongs_to :agent, optional: true
  belongs_to :followee, class_name: User.to_s, counter_cache: :followee_count
  belongs_to :follower, class_name: User.to_s, counter_cache: :follower_count

  validates_uniqueness_of :followee, scope: [:follower]

  scope :with_follower, -> (user) { where(follower: user) }
  scope :with_followee, -> (user) { where(followee: user) }

  def self.page_for_user(page)
    order('id desc').page(page).per(PER_PAGE)
  end

  # @param [User] follower
  # @param [User] followee
  def self.follow(follower, followee)
    if follower.is_a?(User) && followee.is_a?(User)
      criteria = { follower_id: follower.id, followee_id: followee.id }
      find_or_create_by(criteria)
    else
      raise "#{follower.class}, #{followee.class}"
    end
  end

  # @param [User] follower
  # @param [User] followee
  def self.unfollow(follower, followee)
    with_follower(follower).with_followee(followee).destroy_all
  end

  def mutual?
    UserLink.where(follower: followee, followee: follower).exists?
  end
end

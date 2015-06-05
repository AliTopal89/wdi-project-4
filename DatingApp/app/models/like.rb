class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates_uniqueness_of :user_id, scope: [:likeable_id, :likeable_type]
  validate :likeable_user
  

  private

  def likeable_user
    if likeable_type == 'User'
      liker_does_not_equal_liked
    end
  end

  def liker_does_not_equal_liked
    errors.add(:base, 'cannot like yourself') if user_id == likeable_id
  end
end

class Team < ActiveRecord::Base
	has_many :reverse_relationships, foreign_key: "team_id", class_name:  "Relationship", dependent: :destroy
  has_many :users, through: :reverse_relationships

  validates :name, presence: true, length: { maximum: 50 }

  def add_user(user)
  	reverse_relationships.create!(user_id: user.id)
  end

  def remove_user(user)
  	reverse_relationships.find_by(user_id: user.id).destroy
  end

  def includes_user?(user)
  	reverse_relationships.find_by(user_id: user.id)
  end
end

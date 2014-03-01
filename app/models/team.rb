class Team < ActiveRecord::Base
	has_many :reverse_relationships, foreign_key: "team_id", class_name: "Relationship", dependent: :destroy
	has_many :accepted_reverse_relationships, -> { where active: true  }, foreign_key: "team_id", class_name:  "Relationship", dependent: :destroy
	has_many :pending_reverse_relationships, -> { where active: false  }, foreign_key: "team_id", class_name:  "Relationship", dependent: :destroy
  has_many :users, through: :accepted_reverse_relationships, source: :user, class_name: "User"
  has_many :requested_users, through: :pending_reverse_relationships, class_name: "User", source: :user

  validates :name, presence: true, length: { maximum: 50 }

  def accept_requested_user(user)
  	reverse_relationships.find_by(user_id: user.id).update_attribute(:active, true)
  end

  def add_user(user)
  	if pending_reverse_relationships.find_by(user_id: user.id)
  		reverse_relationships.find_by(user_id: user.id).update_attribute(:active, true)
  	else
  		reverse_relationships.create!(user_id: user.id, active: true)
  	end
  end

  def remove_user(user)
  	reverse_relationships.find_by(user_id: user.id).destroy
  end

  def includes_user?(user)
  	accepted_reverse_relationships.find_by(user_id: user.id)
  end

  def includes_request?(user)
  	pending_reverse_relationships.find_by(user_id: user.id)
  end
end

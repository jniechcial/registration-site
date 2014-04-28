class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	before_create :create_remember_token

	validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: /@/ }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :city, presence: true
  validates :tshirt, presence: true, length: { maximum: 3 }
  validates :agreement, :acceptance => { :accept => true }, :on => :create
  validates :terms, :acceptance => { :accept => true }, :on => :create

  has_secure_password

  has_many :relationships, dependent: :destroy
  has_many :accepted_relationships, -> { where active: true }, class_name: 'Relationship', dependent: :destroy
  has_many :pending_relationships, -> { where active: false }, class_name: 'Relationship', dependent: :destroy
  has_many :teams, through: :accepted_relationships, class_name: 'Team', source: :team
  has_many :requested_teams, through: :pending_relationships, class_name: 'Team', source: :team
  has_many :robots, through: :teams

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def request_to_team(team)
  	pending_relationships.create!(team_id: team.id)
  end

  def add_to_team(team)
  	if pending_relationships.find_by(team_id: team.id)
  		relationships.find_by(team_id: team.id).update_attribute(:active, true)
  	else
  		relationships.create!(team_id: team.id, active: true)
  	end
  end

  def remove_from_team(team)
  	relationships.find_by(team_id: team.id).destroy
  end

  def in_team?(team)
  	accepted_relationships.find_by(team_id: team.id)
  end

  def requested_to_team?(team)
  	pending_relationships.find_by(team_id: team.id)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end

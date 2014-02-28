class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	before_create :create_remember_token

	validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  has_secure_password

  has_many :relationships, dependent: :destroy
  has_many :teams, through: :relationships

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def add_to_team(team)
  	relationships.create!(team_id: team.id)
  end

  def remove_from_team(team)
  	relationships.find_by(team_id: team.id).destroy
  end

  def in_team?(team)
  	relationships.find_by(team_id: team.id)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end

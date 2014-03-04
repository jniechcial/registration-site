class Robot < ActiveRecord::Base
	validates :name, presence: true
	belongs_to :team
	belongs_to :competition

	validates :team, presence: true
	validates :competition, presence: true
end

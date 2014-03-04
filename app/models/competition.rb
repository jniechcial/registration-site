class Competition < ActiveRecord::Base
	validates :name, presence: true, uniqueness: { case_sensitive: false }
	has_many :robots
end
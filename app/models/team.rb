class Team < ApplicationRecord
	has_many :credentials
	belongs_to :owner, :class_name => 'User'
	has_many :teamMemberships
	has_many :users, through: :teamMemberships
end
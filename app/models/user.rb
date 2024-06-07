class User < ApplicationRecord
	enum role: [:developer, :manager, :admin]
	has_many :owned_credentials, :class_name => 'Credential', :foreign_key => 'owner_id'
	has_many :owned_teams, :class_name => 'Team'
	has_many :encrypted_credentials, :class_name => 'Credential', :foreign_key => 'encrypted_for_id'
	has_many :teamMemberships
	has_many :teams, through: :teamMemberships
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable
	enum role: [:developer, :manager, :admin]
	has_many :owned_credentials, :class_name => 'Credential', :foreign_key => 'owner_id'
	has_many :owned_teams, :class_name => 'Team', :foreign_key => 'owner_id'
	has_many :encrypted_credentials, :class_name => 'Credential', :foreign_key => 'encrypted_for_id'
	has_many :teamMemberships
	has_many :teams, through: :teamMemberships
	belongs_to :gpg_key, optional: true
end

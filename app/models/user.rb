class User < ApplicationRecord

	# validate password complexity on create/update password
	  validate :password_complexity	
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

	private

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank?

    errors.add(:password, 'must include at least one uppercase letter') unless password.match?(/[A-Z]/)
    errors.add(:password, 'must include at least one lowercase letter') unless password.match?(/[a-z]/)
    errors.add(:password, 'must include at least one digit') unless password.match?(/[0-9]/)
    errors.add(:password, 'must include at least one special character (#?!@$%^&*-)') unless password.match?(/[#!?@$%^&*-]/)
  end
end

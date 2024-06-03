class Credential < ApplicationRecord
	belongs_to :owner, :class_name => "User"
	belongs_to :encrypted_for, :class_name => "User"
end

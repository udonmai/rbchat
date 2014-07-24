class Member < ActiveRecord::Base
	attr_accessible :email, :name

	validates :name, presence: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true,
					format: { with: VALID_EMAIL_REGEX },
					uniqueness: true

	include Gravtastic
	gravtastic

	def self.add(username, email)
		@member = where(name: username).first

		if @member
			return @member
		end

		@member = new
		@member.name = username
		@member.email = email
		@member.save

		return @member
	end	

	def self.get(userId)
		@member = where(id: userId).first
		return @member
	end
end

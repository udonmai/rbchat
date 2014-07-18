class Member < ActiveRecord::Base
  attr_accessible :email, :name

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
					format: { with: VALID_EMAIL_REGEX },
					uniqueness: true

	def add(username, email)
		@member = Member.new
		@member.name = username
		@member.email = email
		@member.save

		return @member
	end	

	def get(userId)
		@member = Member.where(id: userId)
		return @member
	end
end

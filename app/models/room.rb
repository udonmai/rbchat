class Room < ActiveRecord::Base
  attr_accessible :creator, :roomname

  validates :roomname, presence: true
  validates :creator, presence: true

	def get(roomid)
		return '1'
	end
end

class Room < ActiveRecord::Base
	attr_accessible :creator, :roomname

	validates :roomname, presence: true
	validates :creator, presence: true

	def self.add(userId, roomname)
		@room = new
		@room.roomname = roomname
		@room.creator = userId
		@room.save
		@roomid = where(roomname: roomname).first.id

		Redis.sadd(userId + 'created', @roomid)
		Redis.sadd('globalbuilt', @roomid)

		return @roomid
	end

	def self.destroy(userId, roomid)
		@room = where(id: roomid).first
		if userId != @room.creator
			return false
		end

		@room.destroy
		Redis.srem(userId + 'created', roomid)
		
		return true
	end

	def self.modify(newroomname, roomid, userId)
		@room = where(id: roomid).first
		if userId != @room.creator
			return false
		end
		
		@room.roomname = newroomname
		@room.save

		return true
	end

	def self.get(roomid)
		@room = where(id: roomid).first
		if !@room
			return false
		end

		return @room
	end

	def self.join(roomid, userId)
		Redis.sadd('room' + roomid + 'mblist', userId)
		Redis.incr('room' + roomid + 'onlines')

		Redis.incr('globalonlines')

		Redis.zadd(userId + 'latestjoin', Time.now.to_i, roomid)

		@len = Redis.zcard(userId + 'latestjoin')
		if @len > 7
			Redis.zremrangebyrank(userId + 'latestjoin', -1, -1)
		end
	end

	def self.leave(roomid, userId)
		Redis.srem('room' + roomid + 'mblist', userId)

		Redis.decr('room' + roomid + 'onlines')
		Redis.decr('globalonlines')
	end

	def self.onlinemembers(roomid)
		@member = {}
		@members = Redis.smembers('room' + roomid + 'mblist')
		@members.each { |member| 
		@member['name'] = Member.get(member).name
		@member['email'] = Member.get(member).email
		}
	end

end

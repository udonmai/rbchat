class Room < ActiveRecord::Base
  attr_accessible :creator, :roomname

  validates :roomname, presence: true
  validates :creator, presence: true

	def add(userId, roomname)
		@room = Room.new
		@room.roomname = roomname
		@room.creator = userId
		@room.save
		@roomid = Room.where(roomname: roomname).first.id

		Redis.sadd(userId + 'created', @roomid)
		Redis.sadd('globalbuilt', @roomid)

		return @roomid
	end

	def destroy(userId, roomid)
		@room = Room.where(id: roomid).first
		if userId != @room.creator
			return false
		end

		@room.destroy
		Redis.srem(userId + 'created', roomid)
		
		return true
	end

	def modify(newroomname, roomid, userId)
		@room = Room.where(id: roomid)
		if userId != @room.creator
			return false
		end
		
		@room.roomname = newroomname
		@room.save

		return true
	end

	def get(roomid)
		@room = Room.where(id: roomid)
		if !@room
			return false
		end

		return @room
	end

	def join(roomid, userId)
		Redis.sadd('room' + roomid + 'mblist', userId)
		Redis.incr('room' + roomid + 'onlines')

		Redis.incr('globalonlines')

		Redis.zadd(userId + latestjoin, Time.now.to_i, roomid)

		@len = Redis.zcard(userId + 'latestjoin')
		if @len > 7
			Redis.zremrangebyrank(userId + 'latestjoin', -1, -1)
		end
	end

	def leave(roomid, userId)
		Redis.srem('room' + roomid + 'mblist', userId)

		Redis.decr('room' + roomid + 'onlines')
		Redis.decr('globalonlines')
	end

	def onlinemembers(roomid)
		@member = {}
		@members = Redis.smembers('room' + roomid + 'mblist')
		@members.each { |member| 
			@member['username'] = Member.get(member)['username']
			@member['email'] = Member.get(member)['email']
		}
	end

end

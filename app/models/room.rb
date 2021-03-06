# coding: utf-8
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
		require 'digest/md5'

		i = 0
		@member = {}
		@members = Redis.smembers('room' + roomid + 'mblist')
		@members.each { |member| 
			@member[i] = {}
			@member[i]['name'] = Member.get(member).name
			@email = Member.get(member).email
			@hash = Digest::MD5.hexdigest(@email)
			@member[i]['picurl'] = "http://www.gravatar.com/avatar/#{@hash}"
			i += 1
		}
		return @member
	end

end

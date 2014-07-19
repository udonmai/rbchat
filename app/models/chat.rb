class Chat < ActiveRecord::Base
	def self.storemsg(username, roomid, msg, stamp)
		@datatime = stamp['datetime'].strftime("%Y-%m-%d %H:%M:%S")
		@msg = username + '-' + @datatime + msg

		Redis.zadd('room' + roomid.to_s, stamp['datetime'] + stamp['mseconds'], @msg)
		return true
	end	

	def self.getmsg(roomid, stamp)
		return Redis.zrangebyscore('room' + roomid.to_s, stamp['datetime'] + stamp['mseconds'], '+inf')
	end
end

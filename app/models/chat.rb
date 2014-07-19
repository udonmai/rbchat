# coding: utf-8

class Chat < ActiveRecord::Base
	def self.storemsg(username, roomid, msg, stamp)
		@datatime = Time.at(stamp['datetime'].to_i).strftime("%Y-%m-%d %H:%M:%S")
		@msg = username + ' - ' + @datatime + '+' + msg
		if msg == ''
			return
		end
		
		Redis.zadd('room' + roomid.to_s, stamp['datetime'] + stamp['mseconds'], @msg)

		puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
		puts 'STORE ~> ' + stamp.to_s
		puts 'STORE ~> ' + @datatime
		puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'

		return true
	end	

	def self.getmsg(roomid, stamp)
		return Redis.zrangebyscore('room' + roomid.to_s, stamp['datetime'] + stamp['mseconds'], '+inf')
	end
end

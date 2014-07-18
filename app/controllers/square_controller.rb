class SquareController < ApplicationController

	def index
		# test, get from session in production
		@user_id = '1'
		@room = {}

		@selfbuilts = getselfbuilt(@user_id)
		@latestjoins = getlatestjoin(@user_id)
		@globalbuilts = getglobalbuilt(@user_id)

		@selfbuilts.each { |selfbuilt| 
			@tmp_room = Room.get(selfbuilt)
			if !@tmp_room then next end
			@selfbuilt = {}
			@selfbuilt[@tmp_room['roomid']] = {}
			@selfbuilt[@tmp_room['roomid']] = @tmp_room
		}

		@latestjoins.each { |latestjoin| 
			@tmp_room = Room.get(latestjoin)
			if !@tmp_room then next end
			@latestjoin = {}
			@latestjoin[@tmp_room['roomid']] = {}
			@latestjoin[@tmp_room['roomid']] = @tmp_room
		}

		@globalbuilts.each { |globalbuilt| 
			@tmp_room = Room.get(globalbuilt)
			if !@tmp_room then next end
			@globalbuilt = {}
			@globalbuilt[@tmp_room['roomid']] = {}
			@globalbuilt[@tmp_room['roomid']] = @tmp_room
		}

		#@user = Member.get(@user_id)
	end

	def logout
		
	end


	private

	def getglobalbuilt(userId)
		@data = Redis.sdiff('globalbuilt', userId + 'created')
		if @data.size() > 12
			return @data.sample(12)
		else
			return @data
		end
	end

	def getlatestjoin(userId)
		return Redis.zrevrange(userId + 'latestjoin', 0, -1)
	end

	def getselfbuilt(userId)
		return Redis.smembers(userId + 'created')
	end

end

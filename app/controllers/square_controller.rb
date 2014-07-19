class SquareController < ApplicationController

	def index
		# test, get from session in production
		@user_id = '1'
		@selfbuilt = {}
		@latestjoin = {}
		@globalbuilt = {}

		@selfbuilts = getselfbuilt(@user_id)
		@latestjoins = getlatestjoin(@user_id)
		@globalbuilts = getglobalbuilt(@user_id)

		puts @selfbuilts.to_s + '1' + @latestjoins.to_s

		@selfbuilts.each { |selfbuilt| 
			@tmp_room = Room.get(selfbuilt)
			if !@tmp_room then next end
			@selfbuilt[@tmp_room['roomid']] = {}
			@selfbuilt[@tmp_room['roomid']] = @tmp_room
		}

		@latestjoins.each { |latestjoin| 
			@tmp_room = Room.get(latestjoin)
			if !@tmp_room then next end
			@latestjoin[@tmp_room['roomid']] = {}
			@latestjoin[@tmp_room['roomid']] = @tmp_room
		}

		@globalbuilts.each { |globalbuilt| 
			@tmp_room = Room.get(globalbuilt)
			if !@tmp_room then next end
			@globalbuilt[@tmp_room['roomid']] = {}
			@globalbuilt[@tmp_room['roomid']] = @tmp_room
		}

		@user = Member.get(@user_id)
	end

	def logout
		
	end


	private

	def getglobalbuilt(userId)
		@data = Redis.sdiff('globalbuilt', userId.to_s + 'created')
		if @data.size() > 12
			return @data.sample(12)
		else
			return @data
		end
	end

	def getlatestjoin(userId)
		return Redis.zrevrange(userId.to_s + 'latestjoin', 0, -1)
	end

	def getselfbuilt(userId)
		return Redis.smembers(userId.to_s + 'created')
	end

end

class SquareController < ApplicationController

	def index
		
		@user_id = session[:current_user_id]
		@room_id = session[:room_id]

		if !@user_id
			redirect_to '/login'
			return
		end
		
		if (@user_id && @room_id)
			redirect_to '/shitsu'
		end

		@selfbuilt = {}
		@latestjoin = {}
		@globalbuilt = {}

		@selfbuilts = getselfbuilt(@user_id)
		@latestjoins = getlatestjoin(@user_id)
		@globalbuilts = getglobalbuilt(@user_id)

		@selfbuilts.each { |selfbuilt| 
			@tmp_room = Room.get(selfbuilt)
			if !@tmp_room then next end
			@selfbuilt[@tmp_room.id.to_s] = {}
			@selfbuilt[@tmp_room.id.to_s] = @tmp_room
		}

		@latestjoins.each { |latestjoin| 
			@tmp_room = Room.get(latestjoin)
			if !@tmp_room then next end
			@latestjoin[@tmp_room.id.to_s] = {}
			@latestjoin[@tmp_room.id.to_s] = @tmp_room
		}

		@globalbuilts.each { |globalbuilt| 
			@tmp_room = Room.get(globalbuilt)
			if !@tmp_room then next end
			@globalbuilt[@tmp_room.id.to_s] = {}
			@globalbuilt[@tmp_room.id.to_s] = @tmp_room
		}

		@user = Member.get(@user_id)
	end

	def logout
		@user_id = session['current_user_id'] = nil
		redirect_to '/login'
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

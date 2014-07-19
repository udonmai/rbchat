# coding: utf-8

class ShitsuController < ApplicationController
	skip_before_filter  :verify_authenticity_token

	@@_sleepTime = 1.45
	@@_tries = 1

	def index
		@room = {}
		@onlinemembers = {}

		# test
		@user_id = '1'
		@room_id = '1'
		
		@user = Member.get(@user_id)
		@room = Room.get(@room_id)
		@onlinemembers = Room.onlinemembers(@room_id)
	end

	def create
		@user_id = params[:userId]
		@room_name = params[:roomname]
		@room_id = Room.add(@user_id, @room_name)

		@return = {'s' => 'success', 'roomid' => @room_id}

		if @room_id
			render json: @return
		end
	end

	def destroy
		@user_id = params[:userId]
		@room_id = params[:roomid]

		@de = Room.destroy(@user_id, @room_id)
		if !@de
			@return = {'state' => 'fail', 'msg' => '不是您的聊天室，抱歉无法销毁'}
			render json: @return
		else
			@return = {'state' => 'success'}
			render json: @return
		end
	end

	def modify
		@newroomname = params[:newroomname]
		@room_id = params[:roomid]
		@user_id = params[:userId]

		@mo = Room.modify(@newroomname, @room_id, @user_id)
		if !@mo
			@return = {'state' => 'fail', 'msg' => '不是您的聊天室，抱歉无法修改'}
			render json: @return
		else
			@return = {'state' => 'success'}
			render json: @return
		end
	end

	def join
		@room_id = params[:roomid]
		# test
		@user_id = '1'
		
		Room.join(@room_id, @user_id)
		redirect_to '/shitsu'
	end
	
	def leave
		@room_id = params[:roomid]
		# test
		@user_id = '1'

		Room.leave(@room_id, @user_id)
		redirect_to '/square'
	end
	
	def exist
		@room_id = params[:roomid]
		@ex = Room.get(@room_id)
		if !@ex
			@return = {'state' => 'fail'}
			render json: @return
		else
			@return = {'state' => 'success'}
			render json: @return
		end
	end

	def chat
		@username = params[:username]
		@room_id = params[:roomid]
		@msg = params[:message]
		@stamp = params[:stamp]

		@ch = Chat.storemsg(@username, @room_id, @msg, @stamp)

		if !@ch
			@return = {'state' => 'fail'}
			render json: @return
		else
			@return = {'state' => 'success'}
			render json: @return
		end
	end

	def checkupdate
		@room_id = params[:roomid]
		@stamp = params[:stamp]
		@stamp['datetime'] = (@stamp['datetime'].to_i - 3).to_s
		@datatime = Time.at(@stamp['datetime'].to_i).strftime("%Y-%m-%d %H:%M:%S")

		puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
		p @stamp['datetime']
		p @datatime
		puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'

		@i = 0
		while @i < @@_tries
			sleep(@@_sleepTime)
			
			@update = Chat.getmsg(@room_id, @stamp)
			puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
			puts @update
			puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
			if @update.size() > 0
				@return = {'s' => 'exist', 'm' => @update}
				render json: @return and return
			end
			
			@i += 1
		end

		@return = {'s' => 'none'}
		render json: @return
	end

end

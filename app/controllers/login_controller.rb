# coding: utf-8

class LoginController < ApplicationController

	def index
		puts 'udonmai is hero.'

		@user_id = session[:current_user_id]
		if @user_id
			redirect_to '/square'
		end
	end

	def in
		@name = params[:name]
		@email = params[:email]
		@user = Member.add(@name, @email)

		session[:current_user_id] = @user.id.to_s
		flash[:notice] = '进入成功。'
		redirect_to '/square', notice: "欢迎。"
	end

end

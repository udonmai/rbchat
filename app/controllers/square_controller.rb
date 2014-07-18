class SquareController < ApplicationController

	def index
		# test, get from session in production
		@user_id = '1'

		@self_builts = getselfbuilt(@user_id)
		@latest_joins = getlatestjoin(@user_id)
		@global_builts = getglobalbuilt(@user_id)

		

	end


	private

	def getglobalbuilt

	end

	def getlatestjoin
		
	end

	def getselfbuilt
		
	end

end

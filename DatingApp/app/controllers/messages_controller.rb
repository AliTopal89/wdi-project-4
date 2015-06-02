class MessagesController < ApplicationController
	# before_action :authenticate_user!
	
	def index
		@messages = Message.all
	end

	def new
		@message = Message.new
		@recipient = User.find(params[:recipient_id]) if params[:recipient_id]
  	end

  	def message_params
  		params.require(:message).permit(:sender_id, :recipient_username, :recipient_id, :content)
  	end

end
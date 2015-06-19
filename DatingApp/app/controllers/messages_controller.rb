class MessagesController < ApplicationController
	before_action :authenticate_user!

	
	def index
		@messages = Message.all
	end

	def new
		@message = Message.new
		@recipient = User.find(params[:recipient_id]) if params[:recipient_id]
  end

 
 
  def create
  	recipients = User.where(id: params['recipients'])
  	conversation = current_user.send_message(recipients, params[:message][:body], params[:message]).conversation
  	flash[:success] = "Message has been sent!"
    redirect_to conversation_path(conversation)
  end

  private 

  def set_recipient
    self.recipient = User.find_by_username(recipient_username) unless recipient
  end

  	# def message_params
  	# 	params.require(:message).permit(:sender_id, :recipient_username, :recipient_id, :content)
  	# end

end
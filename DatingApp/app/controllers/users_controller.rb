class UsersController < ApplicationController
	before_action :authenticate_user!
	
	def index
		@users = User.all
		@user = User.new
	end

	def show
		sign_out :user 
		redirect_to root_path
	end
	
	def new
		@user = User.new
	end  
    
  	def create
  		@user = User.new(params[:user])
  		if @user.save
  			redirect_to root_url, :notice => "Signed up!"
  		else
  			render :new
  		end
  	end

end
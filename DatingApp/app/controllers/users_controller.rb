class UsersController < ApplicationController
	before_action :authenticate_user!
	
	def index
		if params[:nearby]
			@users = current_user.nearbys(params[:nearby])
		elsif params[:search].present?
			@users = User.near(params[:search], 25, :order => :distance)
		else
			@users = User.all
		end
	end

	def show
		sign_out :user 
		redirect_to root_path
	end

	def new
		@user = User.find(params[:user_id])
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
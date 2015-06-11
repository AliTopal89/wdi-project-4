
class LikesController < ApplicationController
 def destroy
    @likeable = current_user.likes.where(likeable_id: params[:id], likeable_type: params[:type])
    @likeable.destroy_all
    redirect_to :back
  end

  def index
    @likes_me = current_user.likes_me
    @liked_users = current_user.likes
  end

  def create
    puts "PARAMS GOING ON IN HERE"
    puts params
    @likeable = current_user.likes.build(likeable_id: params[:likeable_id], user_id: current_user.id)
    @likeable.save
    redirect_to :back
  end
end
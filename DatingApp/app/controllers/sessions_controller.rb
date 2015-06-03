class SessionsController < Devise::SessionsController 
	# before_action :set_birthday, only: :create
	
	# def set_birthday
	# 	birthday = params[:birthday]
	# 	params[:user][:birthday] = DateTime.new(birthday[:year].to_i, birthday[:month].to_i, birthday[:day].to_i)
	# end

end 
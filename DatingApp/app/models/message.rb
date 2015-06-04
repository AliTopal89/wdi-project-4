class Message < ActiveRecord::Base
	belongs_to :sender, class_name: 'User'
	belongs_to :recipient, class_name: 'User' 
	validates_presence_of :sender, :recipient, :content

	def other_person(user)
    	sender == user ? recipient : sender
  	end
end

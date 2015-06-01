class Message < ActiveRecord::Base
	belongs_to :user
	# validates_presence_of :sender, :recipient, :content
end

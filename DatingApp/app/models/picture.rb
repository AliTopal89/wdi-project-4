class Picture < ActiveRecord::Base
	belongs_to :user

	validates :image_url
end

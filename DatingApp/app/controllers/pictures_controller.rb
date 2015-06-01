 # create_table "pictures", force: :cascade do |t|
 #    t.string   "image_url"
 #    t.string   "caption"
 #    t.integer  "user_id"
 class PicturesController < ApplicationController
	
	def new
		@picture = Picture.new
	end

	def show
	end

	def pic_params
		params.require(:picture).permit(:image_url, :caption)
	end


end
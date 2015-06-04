module ApplicationHelper

	def page_header(text)
		content_for(:page_header) { text.to_s }
	end

	def gravatar_for(user, size = 30, title = user.username)
		image_tag gravatar_image_url(user.username, size: size), title: title, class: 'img-rounded'
	end

	 def header_links
	 	{
	 		likes: header_hash('Likes', likes_path, 'likes'),
      
    	}
  	end
end

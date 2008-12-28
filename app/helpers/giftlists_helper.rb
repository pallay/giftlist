module GiftlistsHelper

	def hidden_div_if(condition, attributes = {})
		if condition
			attributes["style"] = "display: none"
		end
		attrs = tag_options(attributes.stringify_keys)
		"<div#{attrs}>"
	end

	private #-------------------------------------------------------

	def redirect_to_index(msg = nil)
		flash[:notice] = msg if msg
		redirect_to :action => :index
	end
  
end
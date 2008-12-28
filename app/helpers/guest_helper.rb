module GuestHelper

	def hidden_div_if(condition, attributes = {})
		if condition
			attributes["style"] = "display: none"
		end
		attrs = tag_options(attributes.stringify_keys)
		"<div#{attrs}>"
	end

	def display_none(condition, attributes = {})
		if condition
			attributes["style"] = "display: none"
		end
		attrs = tag_options(attributes.stringify_keys)
		"<li id=#{attrs}>"
	end

end

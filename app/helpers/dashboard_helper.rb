module DashboardHelper

	def hidden_div_if(condition, attributes = {})
		if condition
			attributes["style"] = "display: none"
	    end
		attrs = tag_options(attributes.stringify_keys)
		"<div #{attrs}>"
	end

  def format_date(date)
    h date.strftime('%a the %d of %B %Y').gsub(/(\d+)/) { |s| s.to_i < 31?s.to_i.ordinalize : s }
  end

end

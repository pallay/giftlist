class Mailer < ActionMailer::Base

	helper ActionView::Helpers::UrlHelper

	def generic_mailer(options)
		@recipients = options[:recipients] || "pallay@codecrafters.com"
		@from = options[:from] || "pallay@codecrafters.com"
		@cc = options[:cc] || ""
		@bcc = options[:bcc] || "shaadigiftlist@rockytrack.com"
		@subject = options[:subject] || ""
		@body = options[:body] || {}
		@headers = options[:headers] || {}
		@charset = options[:charset] || "utf-8"
		@sent_on = Time.now
	end

	def contact_us(options)
		self.generic_mailer(options)
	end

end

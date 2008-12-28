class Security

	validates_acceptance_of :terms_and_conditions, :message => "You need to confirm you understand the Terms and Conditions"
	validates_inclusion_of :security_question, :in => 2, :message => "You need enter the correct value"

end

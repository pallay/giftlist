class SupportController < ApplicationController

  def index
  end

  def account_creation
    @title = "Account Creation FAQ"  
  end

  def terms
    @title = "Terms and Conditions"  
  end

end

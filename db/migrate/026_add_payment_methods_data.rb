class AddPaymentMethodsData < ActiveRecord::Migration

  def self.up
  	PaymentMethod.create (:name => 'paypal')
  end

  def self.down
  	PaymentMethod.delete_all
  end

end

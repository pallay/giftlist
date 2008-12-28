class AddOrderConditionsData < ActiveRecord::Migration
  def self.up
  	OrderCondition.create (:value => 'customer cancelled')
  	OrderCondition.create (:value => 'administrator cancelled')
  	OrderCondition.create (:value => 'open')
  	OrderCondition.create (:value => 'awaiting payment')
  	OrderCondition.create (:value => 'payment received')
  	OrderCondition.create (:value => 'payment failed')
  	OrderCondition.create (:value => 'awaiting delivery')  	
  	OrderCondition.create (:value => 'completed')  	  	  	
  	OrderCondition.create (:value => 'archived')
  end

  def self.down
  	OrderCondition.delete_all
  end
end

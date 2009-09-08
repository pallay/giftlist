# Subclass so that validations (and all ActiveRecord) is still applied to models with no db tables
# Used for contact.rb

class Tableless < ActiveRecord::Base

  def self.columns()
    @columns ||= [];
  end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  # override the save method to prevent exceptions
  def save(validate = true)
    validate ? valid? : true
  end

end

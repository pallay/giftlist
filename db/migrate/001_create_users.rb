class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table "users", :force => true do |t|
      t.string      :username, :first_name, :last_name, :date_of_birth, :contact_number, :evening_number, :mobile_number, :email, :remember_token
      t.string      :crypted_password,        :limit => 40
      t.string      :salt,                    :limit => 40
      t.string      :activation_code,         :limit => 40
      t.datetime    :remember_token_expires_at, :activated_at
      t.string      :password_reset_code,     :limit => 40
      t.boolean     :enabled,                 :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table "users"
  end

end
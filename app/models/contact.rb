class Contact < Tableless

  column :name,           :string
  column :company,        :string
  column :phone_number,   :string
  column :email_address,  :string
  column :message,        :text

  validates_presence_of :name, :email_address, :message
  validates_format_of   :email_address, :with => /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i
  validates_length_of   :phone_number, :maximum => 12

end
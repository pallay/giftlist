class AddPermissionsData < ActiveRecord::Migration

  def self.up
    # The role migration file needs to be generated first
    Role.create(:role_name => 'administrator')
    # Then, add default admin user
    user = User.new
    user.login = "admin"
    user.email = "talk2us@rockytrack.co.uk"
    user.password = "admin"
    user.password_confirmation = "admin"
    user.save(false)
    user.send(:activate)
    role = Role.find_by_role_name('administrator')
    user = User.find_by_login('admin')
    permission = Permission.new
    permission.role = role
    permission.user = user
    permission.save(false)
    
#    Role.create(:role_name => 'groom')
#    user = User.new
#    user.login = "pallay"
#    user.first_name = "pallay"
#    user.last_name = "raunu"
#    user.date_of_birth = "08/07/1981"
#    user.contact_number = "07711 22 33 44"
#    user.email = "pallay.raunu@googlemail.com"
#    user.password = "pallay"
#    user.password_confirmation = "pallay"
#    user.save(false)
    #user.send(:activate)
#    role = Role.find_by_role_name('groom')
#    user = User.find_by_login('pallay')
#    permission = Permission.new
#    permission.role = role
#    permission.user = user
#    permission.save(false)

    # Create a bride user
#    Role.create(:role_name => 'bride')
#    user = User.new
#    user.login = "palinder"
#    user.first_name = "palinder"
#    user.last_name = "randhawa"
#    user.date_of_birth = "01/02/1983"
#    user.contact_number = "07799 88 77 66"
#    user.email = "palinder@googlemail.com"
#    user.password = "palinder"
#    user.password_confirmation = "palinder"
#    user.save(false)
    #user.send(:activate)
#    role = Role.find_by_role_name('bride')
#    user = User.find_by_login('palinder')
#    permission = Permission.new
#    permission.role = role
#    permission.user = user
#    permission.save(false)

    # Create a guest user
#    Role.create(:role_name => 'guest')
#    user = User.new
#    user.login = "moseeds"
#    user.email = "moseeds@googlemail.com"
#    user.first_name = "mohammed"
#    user.last_name = "seedat"
#    user.date_of_birth = "03/08/1983"
#    user.contact_number = "07711 22 33 44"
#    user.password = "moseeds"
#    user.password_confirmation = "moseeds"
#    user.save(false)
#    #user.send(:activate)
#    role = Role.find_by_role_name('guest')
#    user = User.find_by_login('moseeds')
#    permission = Permission.new
#    permission.role = role
#    permission.user = user
#    permission.save(false)
  end

  def self.down
    Role.find_by_role_name('administrator').destroy   
    User.find_by_login('admin').destroy
  end

end
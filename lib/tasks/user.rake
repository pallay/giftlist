# Here are some rake tasks to manage users in the system.

# This was quickly put together and can do with refactoring at some point

require 'active_record'

# These are the user actions
namespace :user do

  desc "Create user and add to log/users.log"
  task :create => :environment do
    print "Enter: login name?  "
    login = STDIN.gets.gsub(/\n/,"")
    print "password?  "
    password = STDIN.gets.gsub(/\n/,"")
    print "email?  "
    email = STDIN.gets.gsub(/\n/,"")
    filename = "#{RAILS_ROOT}/log/users.log"
    File.open(filename, "a") do |f|
      f.puts
      f.puts "#{login}" + ":".to_s
      f.puts "  login: " + login
      f.puts "  password: " + password
      f.puts "  email: " + email
    end
    puts "...Info written to log/users.log"
    populate_db_save_and_activate(login,password,email)
  end
 
  desc "List all the active users (and their status)"
  task :list => :environment do
    users = User.find(:all)
    output_users(users) do
    end
  end

  desc "Remove defined user data"
  task :remove => :environment do |t|
    users = User.find(:all)
    destroy_users(users) do
    end
  end
  
  desc "Remove all users, and load user data"
  task :recreate => :environment do |t|
    Rake::Task["user:remove"].invoke
    Rake::Task["user:create"].invoke
  end
  
  # These are the user:all actions
  
  namespace :all do
    
    desc "Remove all user data"
    task :remove => :environment do |t|
      users = User.find(:all)
      destroy_users(users) do
      end
    end
    
    desc "Remove all users, and load user data"
    task :recreate => :environment do |t|
      Rake::Task["user:all:remove"].invoke
      Rake::Task["user:create"].invoke
    end
  end
  
  # These are the methods that get called
  
  def populate_db_save_and_activate(login, password, email)
    u = User.new
    u.login = login
    u.email = email
    u.password = password
    u.password_confirmation = password
    if u.save
      puts 'Hurrah! User ' + u.name + ' was created'
    else
      puts 'Whoops! There was an error creating the ' + u.name + u.errors.inspect
      puts 'Looks like the validation failed. Retry: rake recreate'
    end
  end
  
  def output_users(users)
    unless users.empty?
      puts "login"
      puts "--------------"
      users.each do |u|
        puts "#{u.login}"
      end
    else
      puts "Whoops! There were no users to display. Did you add any? rake create to add some"
    end
  end
  
  def destroy_users(users)
    unless users.empty?
       users.each do |u|
         puts 'Hurrah! Destroyed ' + u.name
         u.destroy
       end  
    else
      puts "Whoops! There was nothing to destroy; there's no user-type in the db"
    end
  end
  
end
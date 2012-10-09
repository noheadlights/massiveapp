require 'bundler/capistrano'

set :application, "massiveapp"

set :scm, :git
set :repository, "git@github.com:noheadlights/massiveapp.git"
set :branch, "before_capistrano"

server "localhost", :web, :app, :db, :primary => true

ssh_options[:port] = 2222
ssh_options[:keys] = "~/.vagrant.d/insecure_private_key"

set :user, "vagrant"
set :group, "vagrant"
set :deploy_to, "/var/massiveapp"
set :use_sudo, false

set :deploy_via, :copy
set :copy_strategy, :export

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  desc "Restart the application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  desc "Copy the database.yml file into the latest release"
  task :copy_in_database_yml do
    run "cp #{shared_path}/config/database.yml #{latest_release}/config/"
  end
end
before "deploy:assets:precompile", "deploy:copy_in_database_yml"


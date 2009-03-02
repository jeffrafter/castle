set :domain, 'datadyne.socialrange.org'
set :application, "castle"
set :repository, "git://github.com/jeffrafter/castle.git"
set :keep_releases, 2
set :scm, :git
set :branch, "master"
#set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"
set :user, "deploy"
set :runner, "deploy"
set :use_sudo, :false

role :app, "#{domain}"
role :web, "#{domain}"
role :db,  "#{domain}", :primary => true

# == CONFIG ====================================================================
namespace :init do
  namespace :config do
    desc "Create database.yml"
    task :database do
      if Capistrano::CLI.ui.ask("Create database configuration? (y/n): ") == 'y'
        set :db_name, Capistrano::CLI.ui.ask("database: ")
				set :db_user, Capistrano::CLI.ui.ask("database user: ")
				set :db_pass, Capistrano::CLI.password_prompt("database password: ")			
				database_configuration =<<-EOF
---
login: &login
  adapter: mysql
  host: localhost
  database: #{db_name}
  username: #{db_user}
  password: #{db_pass}

production:
  <<: *login

EOF
				run "mkdir -p #{shared_path}/config"
				put database_configuration, "#{shared_path}/config/database.yml"
		  end		
    end

    desc "Create cron tasks for application"
    task :cron do
      if Capistrano::CLI.ui.ask("Create cron jobs? (y/n): ") == 'y'
        run "cd #{release_path} && whenever --write-crontab"
      end  
    end  

    desc "Symlink shared configurations to current"
    task :localize, :roles => [:app] do
      %w[database.yml].each do |f|
        run "ln -nsf #{shared_path}/config/#{f} #{current_path}/config/#{f}"
      end
    end 		      

  end  
end

# == DEPLOY ====================================================================
namespace :deploy do
  desc "Start application"
  task :start do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Restart application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end  
end  

# == TASKS =====================================================================
after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after "deploy:setup", "init:config:database"
after "deploy:symlink", "init:config:cron"
after "deploy:symlink", "init:config:localize"

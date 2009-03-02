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

    desc "Create cron tasks for success testing, report caching and database backups"
    task :cron do
=begin
      if Capistrano::CLI.ui.ask("Create cron jobs? (y/n): ") == 'y'
     		cron_configuration =<<-EOF
# m h  dom mon dow   command
0 18 * * mon-fri mysqldump -u root relayrelay > #{shared_path}/backup/relayrelay.sql; /usr/local/bin/rsnapshot daily
0 18 * * sat /usr/local/bin/rsnapshot weekly
EOF
        run "mkdir -p #{shared_path}/backup"
        run "echo 'Current cron configuration'"
        run "crontab -l; echo ---"
        put cron_configuration, "#{shared_path}/scripts/cron"
        # Note this overwrites the cron configuration for the deploy user every time, if you have other crontabs you have to do more work
        run "cat #{shared_path}/scripts/cron | crontab -"        
      end  
=end      
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
after "deploy:setup", "init:config:cron"
after "deploy:symlink", "init:config:localize"

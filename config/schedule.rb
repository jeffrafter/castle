set :cron_log, "/var/log/cron_log.log"

every 2.minutes do
  rake 'feeds:fetch'
end  
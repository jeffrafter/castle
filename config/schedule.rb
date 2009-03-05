set :cron_log, "log/cron_log.log"

every 6.minutes do
  rake 'feeds:sync'
end  
set :cron_log, "log/cron_log.log"

every 2.minutes do
  rake 'feeds:fetch'
end  
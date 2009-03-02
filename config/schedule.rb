set :cron_log, "log/cron_log.log"

every 15.minutes do
  rake 'feeds:fetch'
  rake 'feeds:deliver'
end  
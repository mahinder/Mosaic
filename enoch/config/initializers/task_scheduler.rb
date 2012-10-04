scheduler = Rufus::Scheduler.start_new

# scheduler.every("10s") do                # run after every 10 second
# scheduler.cron("*/10 * * * *") do        # run after every 10 minute
scheduler.cron("0 0 * * sun") do           # run every sunday at 12
   PtmMaster.update_master
end

scheduler.cron("1  0 * * *") do            # run every day after 1 minute After midnight
   Employee.birth_day_message_to_all
end 
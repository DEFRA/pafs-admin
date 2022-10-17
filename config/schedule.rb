# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# rubocop:disable Layout/LineLength
job_type :rake, "cd :path && . ../../.exportedenv && :environment_variable=:environment bundle exec rake :task --silent :output"
# rubocop:enable Layout/LineLength

# This is the report sent to admins detailing the projects that were submitted,
# but that have not been received by PoL
every :day, at: "09:30" do
  rake "admin:send_failure_report"
end

every :day, at: "08:30" do
  rake "admin:send_success_report"
end

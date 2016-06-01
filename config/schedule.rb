every 1.day, at: '2am' do
  runner 'DailyDigestJob.perform_now'
end

every 60.minutes do
  rake 'ts:index'
end

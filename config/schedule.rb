every 1.day, at: "2am" do
  runner "DailyDigestJob.perform_now"
end

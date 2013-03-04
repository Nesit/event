Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.max_attempts = 3
Delayed::Worker.sleep_delay = 30
Delayed::Worker.max_run_time = Rails.env.production? ? 3.minutes : 1.hour
Delayed::Worker.delay_jobs = !Rails.env.test? || !Rails.env.development?

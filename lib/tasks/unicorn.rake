namespace :unicorn do
  task :reload do
    pidfile = Rails.root.join('tmp/pids/unicorn.pid')
    raise "Unicorn pid file #{pidfile} does not exist" unless File.exist?(pidfile)
    if %x[kill -s USR2 `cat #{pidfile}`]
      puts "Unicorn was be reloaded"
    else
      puts "Unicorn was not be reloaded. Somethind wrong"
    end
  end
end

namespace :maintenance do
  desc "Enable to maintenance mode"
  task :on do
    print "Enabling maintenance mode... "
    on roles(:all) do
      execute("sudo mkdir -pv /etc/nginx/switch || true")
      execute("sudo touch /etc/nginx/switch/maintenance")
    end
    puts "done"
  end

  desc "Disable to maintenance mode"
  task :off do
    print "Disabling maintenance mode... "
    on roles(:all) do
      execute("sudo mkdir -pv /etc/nginx/switch || true")
      execute("sudo rm /etc/nginx/switch/maintenance || true")
    end
    puts "done"
  end
end

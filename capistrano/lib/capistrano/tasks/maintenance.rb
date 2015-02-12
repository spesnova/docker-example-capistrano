namespace :maintenance do
  desc "Enable to maintenance mode"
  task :on do
    on roles(:all) do
      execute("sudo touch /etc/nginx/switch/maintenance")
    end
  end

  desc "Disable to maintenance mode"
  task :off do
    on roles(:all) do
      execute("sudo rm /etc/nginx/switch/maintenance")
    end
  end
end

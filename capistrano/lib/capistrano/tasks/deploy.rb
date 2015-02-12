namespace :deploy do
  desc "Switch to blue containers"
  task :switch_to_blue do
    on roles(:all) do
      execute("sudo touch /etc/nginx/switch/blue")
      execute("sudo rm    /etc/nginx/switch/green || true")
    end
  end

  desc "Switch to green containers"
  task :switch_to_green do
    on roles(:all) do
      execute("sudo touch /etc/nginx/switch/green")
      execute("sudo rm    /etc/nginx/switch/blue || true")
    end
  end
end

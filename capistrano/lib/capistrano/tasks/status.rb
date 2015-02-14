desc "Show color(blue/green) and maintenance mode(on/off)"
task :status do
  maintenance = false
  on roles(:cap) do
    maintenance = test("ls /etc/nginx/switch/maintenance")
  end
  puts "Maintenance Mode: #{maintenance}"
  puts "Current Color:    #{current_color}"
end

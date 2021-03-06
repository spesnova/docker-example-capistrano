def current_color
  to = ""
  on roles(:cap) do
    to = test("ls /etc/nginx/switch/blue") ? "blue" : "green"
  end
  to
end

def next_color
  to = ""
  on roles(:cap) do
    to = test("ls /etc/nginx/switch/blue") ? "green" : "blue"
  end
  to
end

desc "Deploy an app"
task :deploy do
  invoke "pull"
  invoke "unit:reload"
  invoke "ps:restart"
end

namespace :deploy do
  desc "Switch to blue/green containers"
  task :switch, :to do |t, args|
    to = ""
    to = args[:to]  if args[:to] == "blue" || args[:to] == "green"
    to = next_color if to == ""

    from = "blue"
    from = "green" if to == "blue"

    print "Swiching to #{to} containers... "

    on roles(:all) do
      execute("sudo mkdir -pv /etc/nginx/switch || true")
      execute("sudo touch     /etc/nginx/switch/#{to}")
      execute("sudo rm        /etc/nginx/switch/#{from} || true")
    end

    puts "done"
  end
end

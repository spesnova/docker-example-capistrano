require "erb"
require "json"

desc "List containers for an app"
task :ps do
  machines = []

  on roles(:all) do |m|
    machines << {
      ip: m.hostname,
      ps_json: capture("curl #{fetch(:api_endpoint)}/#{fetch(:api_version)}/containers/json?all=true")
    }
  end

  rows = []
  machines.each do |m|
    JSON.parse(m[:ps_json]).each do |c|
      ports = ""
      c["Ports"].each do |port|
        ports << "#{port['IP']}:#{port['PublicPort']}->#{port['PrivatePort']}/#{port['Type']}"
      end
      rows << [m[:ip], c["Id"].slice!(0..6), c["Names"].first.sub(/\//,''), c["Status"], ports, c["Command"]]
    end
  end

  rows.sort_by!{|row| row[2]}
  rows.sort_by!{|row| row[0]} if ENV["SORT_BY"] == "host"
  rows.unshift(["MACHINE", "ID", "NAME", "STATUS", "PORTS", "COMMAND"])
  rows.each do |r|
    puts r[0].ljust(15) + r[1].ljust(10) + r[2].ljust(30) + r[3].ljust(25) + r[4].ljust(25) + r[5]
  end
end

namespace :ps do
  desc "Start containers for an app"
  task :start do
    container   = fetch(:container)
    print "Starting #{container}... "
    on roles(fetch(:stage)) do
      execute("sudo systemctl enable #{container}.service")
      execute("sudo systemctl start #{container}.service")
    end
    puts "done"
  end

  desc "Restart containers for an app"
  task :restart do
    container = fetch(:container)
    print "Restarting #{container}... "
    on roles(fetch(:stage)) do
      execute("sudo systemctl restart #{container}.service")
    end
    puts "done"
  end

  desc "Stop containers for an app"
  task :stop do
    container = fetch(:container)
    print "Stopping #{container}... "
    on roles(fetch(:stage)) do
      execute("sudo systemctl stop #{container}.service")
    end
    puts "done"
  end

  desc "Kill containers for an app"
  task :kill do
    container = fetch(:container)
    print "Killing #{container}... "
    on roles(fetch(:stage)) do
      execute("sudo systemctl kill #{container}.service")
    end
    puts "done"
  end
end

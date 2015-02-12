require "erb"
require "json"

desc "List containers for an app"
task :ps do
  machines = []

  on roles(:all) do |m|
    machines << {
      ip: m.hostname,
      ps_json: capture("curl #{fetch(:api_endpoint)}/#{fetch(:api_version)}/containers/json")
    }
  end

  rows = [["MACHINE", "ID", "NAME", "STATUS", "COMMAND"]]

  machines.each do |m|
    JSON.parse(m[:ps_json]).each do |c|
      rows << [m[:ip], c["Id"].slice!(0..6), c["Names"].first.sub(/\//,''), c["Status"], c["Command"]]
    end
  end

  rows.each do |r|
    puts r[0].ljust(15) + r[1].ljust(10) + r[2].ljust(30) + r[3].ljust(18) + r[4].ljust(15)
  end
end

namespace :ps do
  desc "Start containers for an app"
  task :start do
    description = fetch(:description)
    container   = fetch(:container)
    image       = fetch(:image)
    options     = fetch(:options)
    command     = fetch(:command)

    template_path = ::File.expand_path("../../../../templates/container.service.erb", __FILE__)
    template      = ::ERB.new(File.new(template_path).read).result(binding)
    tmp_path      = "/tmp/#{container}.service"
    dest_path     = "/etc/systemd/system/#{container}.service"

    on roles(:all) do
      upload!(StringIO.new(template), tmp_path)
      execute("sudo cp #{tmp_path} #{dest_path}")
      execute("sudo chmod 644 #{dest_path}")
      execute("sudo chown root:root #{dest_path}")
      execute("sudo systemctl enable #{container}.service")
      execute("sudo systemctl start  #{container}.service")
    end
  end

  desc "Restart containers for an app"
  task :restart do
    container = fetch(:container)

    on roles(:all) do
      execute("sudo systemctl restart #{container}.service")
    end
  end

  desc "Stop containers for an app"
  task :stop do
    container = fetch(:container)

    on roles(:all) do
      execute("sudo systemctl stop #{container}.service")
    end
  end

  desc "Kill containers for an app"
  task :kill do
    container = fetch(:container)

    on roles(:all) do
      execute("sudo systemctl kill #{container}.service")
    end
  end
end

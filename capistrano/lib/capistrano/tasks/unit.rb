namespace :unit do
  desc "Load/Reload unit file"
  task :reload do
    description = fetch(:description)
    container   = fetch(:container)
    image       = fetch(:image)
    options     = fetch(:options)
    command     = fetch(:command)

    print "Reloading #{container}... "

    template_path = ::File.expand_path("../../../../templates/container.service.erb", __FILE__)
    template      = ::ERB.new(File.new(template_path).read).result(binding)
    tmp_path      = "/tmp/#{container}.service"
    dest_path     = "/etc/systemd/system/#{container}.service"

    on roles(:all) do
      upload!(StringIO.new(template), tmp_path)
      execute("sudo cp #{tmp_path} #{dest_path}")
      execute("sudo chmod 644 #{dest_path}")
      execute("sudo chown root:root #{dest_path}")
      execute("sudo systemctl daemon-reload")
    end

    puts "done"
  end

  desc "Cat systemd unit file on each machine for an app"
  task :cat do
    container = fetch(:container)
    target_path  = "/etc/systemd/system/#{container}.service"
    dest_path    = "/tmp/#{container}.service"

    on roles(:all, in: :sequence) do |m|
      if test("ls #{target_path}")
        download!(target_path, dest_path)
        puts ""
        puts "----- #{m.hostname} --------------------------------------"
        puts File.new(dest_path).read
        puts "---------------------------------------------------------"
        puts ""
      else
        puts ""
        puts "----- #{m.hostname} --------------------------------------"
        puts "---------------------------------------------------------"
        puts ""
      end
    end
  end

  desc "Cat generated unit file for checking"
  task :check do
    description = fetch(:description)
    container   = fetch(:container)
    image       = fetch(:image)
    options     = fetch(:options)
    command     = fetch(:command)

    template_path = ::File.expand_path("../../../../templates/container.service.erb", __FILE__)
    puts ::ERB.new(File.new(template_path).read).result(binding)
  end
end

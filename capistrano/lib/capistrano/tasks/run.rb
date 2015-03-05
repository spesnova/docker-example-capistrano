desc "Run one-off container for an app"
task :run do
  if fetch(:stage) == "default"
    abort "Please specify app to run. Example: $ cap rails-blue run"
  end

  ask(:command, "/bin/bash", echo: true)

  container   = "#{fetch(:container)}.run.#{Time.now.to_i}"
  image       = fetch(:image)
  options     = fetch(:options)
  command     = fetch(:command)

  docker_command = [
    "/usr/bin/docker",
    "run",
    "-it",
    "--rm",
    "--name #{container}",
    "#{options}",
    "#{image}",
    "#{command}",
  ].join(" ")

  ssh_command = [
    "ssh",
    "-t",
    "-i #{fetch(:ssh_options)[:keys].first}",
    "-o StrictHostKeyChecking=no",
    "-o UserKnownHostsFile=/dev/null",
    "-o LogLevel=quiet",
    "#{fetch(:ssh_options)[:user]}@#{roles(:cap).first.hostname}",
    "'#{docker_command}'",
  ].join(" ")

  puts "Running #{command}... up, #{container}"
  exec(ssh_command)
end

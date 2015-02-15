require "yaml"

#
# Capistrano Version
#
lock "3.3.5"

#
# Output
#
set :format, :pretty
set :pty, true

#
# Log Level
#
set :log_level, case ENV["LOG_LEVEL"]
                when "trace" then :trace
                when "debug" then :debug
                when "info"  then :info
                when "warn"  then :warn
                when "error" then :error
                when "fatal" then :fatal
                else :warn
                end

#
# SSH Options
#
set :ssh_options, {
  user:          "cap",
  keys:          ["/capistrano/ssh/cap.pem"],
  forward_agent: true,
  auth_methods:  %w(publickey)
}

#
# Roles
#
role "cap",                ["172.17.8.101"]
role "build",              ["172.17.8.101"]
role "postgres",           ["172.17.8.101"]
role "prometheus",         ["172.17.8.101"]
role "container-exporter", ["172.17.8.101"]
role "nginx",              ["172.17.8.102", "172.17.8.103"]
role "rails-blue",         ["172.17.8.102", "172.17.8.103"]
role "rails-green",        ["172.17.8.102", "172.17.8.103"]
role "cadvisor",           ["172.17.8.101", "172.17.8.102", "172.17.8.103"]
role "logspout",           ["172.17.8.101", "172.17.8.102", "172.17.8.103"]

#
# Docker Remote API
#
set :api_endpoint, "http://localhost:2375"
set :api_version,  "v1.16"

#
# Helpers
#
def load_app_config
  config = YAML.load_file("config/app/#{fetch(:stage).to_s}.yml")

  if config["name"].nil? || config["name"].empty?
    abort "App name is required! Please specify it in your yaml"
  end
  options = ["--name #{config['name']}"]

  unless config["environment"].nil? || config["environment"].empty?
    options += config["environment"].map { |env| "-e #{env}" }
  end

  unless config["volumes"].nil? || config["volumes"].empty?
    options += config["volumes"].map { |vol| "-v #{vol}" }
  end

  unless config["ports"].nil? || config["ports"].empty?
    options += config["ports"].map { |port| "-p #{port}" }
  end

  unless config["net"].nil? || config["net"].empty?
    options << "--net=#{config['net']}"
  end

  set :description, config["description"]
  set :container,   config["name"]
  set :image,       config["image"]
  set :options,     options.join(" ")
  set :command,     config["command"]
  set :repo,        config["repo"]
end

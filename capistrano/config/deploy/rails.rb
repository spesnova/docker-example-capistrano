set :stage, :rails

#
# Roles
#
role :rails, ["172.17.8.102", "172.17.8.103"]

#
# SSH options
#
set :ssh_options, {
  user:          "cap",
  keys:          ["/capistrano/ssh/cap.pem"],
  forward_agent: true,
  auth_methods:  %w(publickey)
}

#
# Rails App Container
#
options = [
  "--name docker-example-rails-blue",
  "-e DATABASE_HOST='172.17.8.101'",
  "-e DATABASE_PORT='5432'",
  "-e DATABASE_USER='hello'",
  "-e DATABASE_PASSWORD='world'",
  "-e SECRET_KEY_BASE='450a851180c712e6a7ba6f4ab4a9624caddfc02d842eef3315cc47f9b0a16ef3cb5e5b68184d998604076a05d32d108b465f7bfe23623222690be720c7bfd39c'",
  "-e RACK_ENV=production",
  "-e RAILS_SERVE_STATIC_FILES=true",
  "-p 8091:3000",
]
set :description, "Example Rails App"
set :container  , "docker-example-rails-blue"
set :image      , "quay.io/spesnova/docker-example-rails"
set :options    , options.join(" ")
set :command    , ""

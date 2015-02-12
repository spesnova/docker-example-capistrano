set :stage, :nginx

#
# Roles
#
role :nginx, ["172.17.8.102", "172.17.8.103"]

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
# Nginx Proxy Container
#
options = [
  "--name #{fetch(:container)}",
  "-e SERVERNAME='hello.com'",
  "-v /etc/nginx/switch:/etc/nginx/switch:ro",
  "--net=host",
]
set :description, "Example Nginx Proxy"
set :container  , "docker-example-nginx"
set :image      , "quay.io/spesnova/docker-example-nginx"
set :options    , options.join(" ")
set :command    , ""

desc "login to docker registry"
task :login do
  ask(:Registry, "quay.io", echo: true)
  ask(:Username, nil,       echo: true)
  ask(:Password, nil,       echo: false)
  ask(:Email,    nil,       echo: true)

  registry = fetch(:Registry)
  username = fetch(:Username)
  password = fetch(:Password)
  email    = fetch(:Email)

  args = [
    "--username=#{username}",
    "--password=#{password}",
    "--email=#{email}",
    registry,
  ].join(" ")

  on roles(:all) do |m|
    if test("docker login #{args}")
      puts [m.hostname, "Login Succeeded"].join("  ")
    else
      puts [m.hostname, "Login Failed"].join("  ")
    end
  end
end

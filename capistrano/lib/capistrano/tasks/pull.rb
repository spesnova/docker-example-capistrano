desc "Pull docker image for an app"
task :pull do
  image = fetch(:image)
  on roles(:all) do
    execute("docker pull #{image}")
  end
end

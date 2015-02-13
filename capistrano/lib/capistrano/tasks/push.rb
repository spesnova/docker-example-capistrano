desc "Push docker image to registry"
task :push do
  image    = fetch(:image)
  on roles(:build) do
    execute("docker push #{image}")
  end
end

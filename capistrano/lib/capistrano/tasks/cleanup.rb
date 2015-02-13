desc "Remove untagged images and exited containers"
task :cleanup do
  invoke "cleanup:images"
  invoke "cleanup:containers"
end

namespace :cleanup do
  desc "Remove untagged images"
  task :images do
    on roles(:all) do
      execute('docker rmi $(docker images -f "dangling=true" -q) || true')
    end
  end

  desc "Remove exited containers"
  task :containers do
    on roles(:all) do
      execute('docker rm $(docker ps -afq status=exited) || true')
    end
  end
end

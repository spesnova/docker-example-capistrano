desc "Remove untagged images and exited containers"
task :cleanup do
  invoke "cleanup:images"
  invoke "cleanup:containers"
end

namespace :cleanup do
  desc "Remove untagged images"
  task :images do
    print "Cleaning up untagged images... "
    on roles(:all) do
      execute('docker rmi $(docker images -f "dangling=true" -q) || true')
    end
    puts "done"
  end

  desc "Remove exited containers"
  task :containers do
    print "Cleaning up exited containers... "
    on roles(:all) do
      execute('docker rm $(docker ps -afq status=exited) || true')
    end
    puts "done"
  end
end

desc "Hello World"
task :hello do
  on roles(:all) do
    puts capture('echo "Hello from $(hostname) !"')
  end
end

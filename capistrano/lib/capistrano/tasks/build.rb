desc "Build docker image for an app"
task :build do
  image    = fetch(:image)
  repo     = fetch(:repo)
  branch   = ENV["BRANCH"] || "master"
  src_path = "/home/cap/src/#{repo}"

  output = "Building #{image}..."

  progressbar_thread = Thread.new do
    options = {
      title: output,
      total: nil,
      length: (output.length + 4),
      format: "%t %B",
      unknown_progress_animation_steps: ['o..', '.o.', '..o'],
    }
    progressbar = ProgressBar.create(options)

    loop do
      sleep 0.3
      progressbar.increment
    end
  end

  execution_thread = Thread.new do
    on roles(:build) do
      unless test("ls #{src_path}/.git")
        execute("git clone http://#{repo}.git #{src_path}")
      end

      # FIXME: within syntax doesn't work for me :(
      execute("cd #{src_path} && git fetch -p")
      execute("cd #{src_path} && git checkout #{branch}")
      execute("cd #{src_path} && git pull origin #{branch}")

      if test("ls #{src_path}/script/build")
        execute("#{src_path}/script/build")
      else
        execute("cd #{src_path} && docker build #{image} .")
      end
    end
    progressbar_thread.kill
  end

  progressbar_thread.join
  execution_thread.join

  puts "#{output} done"
end

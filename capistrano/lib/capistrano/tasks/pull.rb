require "ruby-progressbar"

desc "Pull docker image for an app"
task :pull do
  image = fetch(:image)
  output = "Pulling #{image}..."

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
    on roles(:all) do
      execute("docker pull #{image}")
    end
    progressbar_thread.kill
  end

  progressbar_thread.join
  execution_thread.join

  puts "#{output} done"
end

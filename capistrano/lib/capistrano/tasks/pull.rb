require "ruby-progressbar"

desc "Pull docker image for an app"
task :pull do
  image = fetch(:image)
  output = "Pulling latest #{image}..."

  download_bar_thread = Thread.new do
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

  pull_thread = Thread.new do
    on roles(:all) do
      execute("docker pull #{image}")
    end
    download_bar_thread.kill
  end

  download_bar_thread.join
  pull_thread.join

  puts "#{output} done"
end

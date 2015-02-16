desc "Push docker image to registry"
task :push do
  image = fetch(:image)
  output = "Pushing #{image}..."

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
      execute("docker push #{image}")
    end
    progressbar_thread.kill
  end

  progressbar_thread.join
  execution_thread.join

  puts "#{output} done"
end

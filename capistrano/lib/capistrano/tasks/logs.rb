require "net/http"

def puts_log_stream(endpoint)
  uri = URI.parse(endpoint)
  Net::HTTP.start(uri.host, uri.port) do |http|
    request = Net::HTTP::Get.new uri.request_uri

    http.request request do |response|
      response.read_body do |chunk|
        puts "#{uri.host}|#{chunk}"
      end
    end
  end
end

desc "Display continually stream logs"
task :logs do
  puts "Type CTRL+C to stop streaming"

  filter = ""
  filter = fetch(:container)   unless fetch(:stage) == :default
  filter = ENV['FILTER']       unless ENV['FILTER'].nil? || ENV['FILTER'].empty?
  filter = "filter:#{filter}" unless filter == ""

  begin
    threads = []
    roles(:all).each do |m|
      threads << Thread.new do
        puts_log_stream(["http://#{m.hostname}:8000/logs", filter].join("/"))
      end
    end
    threads.each { |t| t.join }
  rescue Interrupt
    puts
    puts " !    Command cancelled."
  end
end

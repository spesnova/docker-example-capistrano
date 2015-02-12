lock "3.3.5"

set :format, :pretty
set :pty, true

#
# Log Level
#
set :log_level, case ENV["LOG_LEVEL"]
                when "trace" then :trace
                when "debug" then :debug
                when "info"  then :info
                when "warn"  then :warn
                when "error" then :error
                when "fatal" then :fatal
                else :info
                end

#
# Docker
#
set :api_endpoint, "http://localhost:2375"
set :api_version,  "v1.16"

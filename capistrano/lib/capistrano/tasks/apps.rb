desc "List apps (stage)"
task :apps do
  puts stages.reject!{|s| s == "hidden"}
end

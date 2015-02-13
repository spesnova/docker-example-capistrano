desc "List docker images per host"
task :images do
  machines = []

  on roles(:all) do |m|
    machines << {
      ip: m.hostname,
      images_json: capture("curl #{fetch(:api_endpoint)}/#{fetch(:api_version)}/images/json")
    }
  end

  rows = []
  machines.each do |m|
    JSON.parse(m[:images_json]).each do |c|
      rows << [m[:ip], c["RepoTags"].first, c["Id"].slice!(0..6), Time.at(c["Created"]).strftime("%Y/%m/%d/%H:%M")]
    end
  end

  rows.sort_by!{|row| row[1]}
  rows.unshift(["MACHINE", "IMAGE", "ID", "CREATED"])
  rows.each do |r|
    puts r[0].ljust(15) + r[1].ljust(50) + r[2].ljust(10) + r[3].ljust(25)
  end
end

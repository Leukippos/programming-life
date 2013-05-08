namespace :gems do
  desc "Spit out gems.yml and .gems in root of app (for Heroku + EY etc.)"
  task :specify => :environment do
    gems = Gem.loaded_specs
    
    # output gems.yml
    yaml = Rails.root.join("gems.yml")
    File.open(yaml, "w") do |f|
      output = []
      gems.each do |key, gem|
        spec = { "name" => gem.name, "version" => gem.version.to_s }
        spec["install_options"] = "--source #{gem.source}" if gem.source
        output << spec
      end
      f.write output.to_yaml
      puts output.to_yaml
    end
    
    # output .gems
    dot_gems = Rails.root.join(".gems")
    File.open(dot_gems, "w") do |f|
      output = []
      gems.each do |key, gem|
        spec = "#{gem.name} --version '#{gem.version.to_s}'"
        spec << " --source #{gem.source}" if gem.source
        output << spec
      end
      f.write output.join("\n")
      puts output.join("\n")
    end
  end
end
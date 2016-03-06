namespace :config do
	desc 'Generate zone files'
	task :generate do
		config_dir = ENV['CONFIG_DIR'].nil? ? '/srv/data/config' : ENV['CONFIG_DIR']
		bind_dir = ENV['BIND_DIR'].nil? ? '/srv/data/etc' : ENV['BIND_DIR']

		puts "Loading configuration from #{config_dir}"
		config = YAML.load_file File.join(config_dir, 'main.yml')

		puts "Generating named config in #{bind_dir}"
		FileUtils.mkdir_p File.join(bind_dir, 'zones')
		template = NamedTemplate.new config
		template.write bind_dir

		config['domains'].each_pair do |domain, data|
			puts "Generating hosts file for #{domain}"
			FileUtils.mkdir_p File.join(bind_dir, 'zones')
			template = ZoneTemplate.new domain, data, config
			template.write bind_dir
		end

		puts 'Reloading configuration'
		`rndc reload`
	end
end

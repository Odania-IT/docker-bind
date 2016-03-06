namespace :config do
	desc 'Generate zone files'
	task :generate do
		bind_type = ENV['BIND_TYPE'].nil? ? 'master' : ENV['BIND_TYPE']
		is_master = 'master'.eql? bind_type
		config_dir = ENV['CONFIG_DIR'].nil? ? '/srv/data/config' : ENV['CONFIG_DIR']
		bind_dir = ENV['BIND_DIR'].nil? ? '/srv/data/etc' : ENV['BIND_DIR']
		FileUtils.mkdir_p File.join(bind_dir, 'zones')

		puts "Loading configuration from #{config_dir}"
		config = YAML.load_file File.join(config_dir, 'main.yml')

		puts "Generating named config in #{bind_dir}"
		FileUtils.mkdir_p File.join(bind_dir, 'zones')
		template = NamedTemplate.new config, is_master
		template.write bind_dir

		if is_master
			config['domains'].each_pair do |domain, data|
				puts "Generating hosts file for #{domain}"
				template = ZoneTemplate.new domain, data, config
				template.write bind_dir
			end
		end

		puts 'Reloading configuration'
		`rndc reload`
	end
end

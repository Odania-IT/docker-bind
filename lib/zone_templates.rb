class ZoneTemplate
	attr_accessor :template, :domain, :config, :global_config

	def initialize(domain, config, global_config)
		self.domain = domain
		self.config = config
		self.global_config = global_config
		self.template = File.new(File.join(BASE_DIR, 'templates', 'db-entry.erb')).read
	end

	def render
		Erubis::Eruby.new(self.template).result(binding)
	end

	def write(out_dir)
		File.write(File.join(out_dir, 'zones', "#{domain}.hosts"), self.render)
	end
end

class NamedTemplate
	attr_accessor :template, :config

	def initialize(config)
		self.config = config
		self.template = File.new(File.join(BASE_DIR, 'templates', 'named.conf.erb')).read
	end

	def render
		Erubis::Eruby.new(self.template).result(binding)
	end

	def write(out_dir)
		File.write(File.join(out_dir, 'named.conf.local'), self.render)
	end
end

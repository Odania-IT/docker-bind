class NamedTemplate
	attr_accessor :template, :config, :is_master

	def initialize(config, is_master)
		self.is_master = is_master
		self.config = config
		self.template = File.new(File.join(BASE_DIR, 'templates', 'named.conf.local.erb')).read
	end

	def render
		Erubis::Eruby.new(self.template).result(binding)
	end

	def write(out_dir)
		File.write(File.join(out_dir, 'named.conf.local'), self.render)
	end

	def get_master
		config['nameservers'].each do |data|
			return data['ip'] if 'master'.eql? data['type']
		end

		'ERROR-NO-MASTER-FOUND'
	end
end

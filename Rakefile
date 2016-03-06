require 'yaml'
require 'erubis'

require_relative 'lib/named_template'
require_relative 'lib/zone_templates'

BASE_DIR = File.absolute_path File.dirname(__FILE__)

Dir.glob('tasks/**/*.rake').each(&method(:import))

task :default => [:spec]

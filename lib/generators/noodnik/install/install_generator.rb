module Noodnik
	module Generators
		class InstallGenerator < Rails::Generators::Base
			source_root File.expand_path('../templates', __FILE__)

			def generate_initializer
				copy_file 'initializer.rb', 'config/initializers/noodnik.rb'
			end
		end
	end
end

require 'noodnik/view_helpers'

module Noodnik
	class Railtie < Rails::Railtie
		initializer "noodnik.view_helpers" do
			ActionView::Base.send :include, ViewHelpers
		end
	end
end

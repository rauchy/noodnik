module Noodnik
	class Railtie < Rails::Railtie
		initializer "noodnik.view_helpers" do
			ActionView::Base.send :include, NagsHelper
		end
	end
end

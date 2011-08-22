module Noodnik
	module NagsHelper
	  include Rails.application.routes.mounted_helpers  

		def nag_user_to(topic)
			nag = find_nag(topic)
			return if nag && nag.next_nag > Time.now
			yield
		end


		private

		def find_nag(topic)
			attr = { user_id: Noodnik.current_user_id.call, topic: topic }
			Nag.find :first, conditions: attr
		end

		class Context
			attr_accessor :topic, :helper, :url_helpers

			def initialize(topic, helper, url_helpers)
				@topic = topic
				@helper = helper
				@url_helpers = url_helpers
			end

		  def postpone_for(period)
				helper.link_to "Remind me in #{period.inspect}", @url_helpers.postpone_path(period: period, topic: @topic), class: 'postpone-link'
			end
		end
	end
end

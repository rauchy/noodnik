module Noodnik
	module NagsHelper
		def nag_user_to(topic)
			nag = find_nag(topic)
			return if nag && nag.next_nag > Time.now
			content_tag :div, :"data-noodnik-topic" => topic do
				yield
			end
		end

		def postpone_for(period)
			link_to "Remind me in #{period.inspect}", noodnik.routes.url_helpers.postpone_path(period: period, topic: @noodnik_topic), class: 'postpone-link'
		end

		private

		def find_nag(topic)
			attr = { user_id: Noodnik.current_user_id.call, topic: topic }
			Nag.find :first, conditions: attr
		end
	end
end

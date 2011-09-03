module Noodnik
	module NagsHelper
		def nag_user_to(topic, &block)
			nag = find_nag(topic)
			return if nag && (nag.next_nag > Time.now || nag.completed?)

			begin
	 		  class_eval('alias :original_link_to :link_to')
		    class_eval('alias :link_to :my_custom_link_to')
				Context.new.local_eval do
					@noodnik_topic = topic
					content_tag :div, class: 'noodnik-nag' do
						capture(&block)
					end
				end
		  ensure
				@noodnik_topic = nil
		    class_eval('alias :link_to :original_link_to')
		  end
		end

		private

		def find_nag(topic)
			attr = { user_id: Noodnik.current_user_id.call, topic: topic }
			Nag.find :first, conditions: attr
		end

		def my_custom_link_to(*args)
			has_options = args.last.is_a? Hash
			html_options = has_options ? args.last : {}
			html_options["data-noodnik-topic"] = @noodnik_topic
			html_options["data-noodnik-complete-path"] = noodnik.routes.url_helpers.complete_path(topic: @noodnik_topic)
			
			if html_options.include? :class
				html_options[:class] += " noodnik-complete"
			else
				html_options[:class] = "noodnik-complete"
			end

			args << html_options unless has_options
			original_link_to *args
		end

		class Context
			include Rails.application.routes.mounted_helpers
		  def postpone_for(period)
				original_link_to "Remind me in #{period.inspect}", noodnik.routes.url_helpers.postpone_path(period: period, topic: @noodnik_topic), class: 'noodnik-postpone'
			end
		end
	end
end

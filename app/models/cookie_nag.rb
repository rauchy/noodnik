class CookieNag
	def initialize(topic, cookies)
		@next_nag = cookies[topic]
	end

	def due?
		case @next_nag
		when NilClass
			true
		when ActiveSupport::TimeWithZone
			@next_nag < Time.now
		when String
			@next_nag != 'complete'
		end
	end
end

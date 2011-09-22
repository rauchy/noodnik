class CookieNag
	def initialize(topic, cookies)
		@next_nag = cookies[topic]
	end

	def due?
		return false if @next_nag == 'complete'
	  time = ActiveSupport::TimeZone['UTC'].parse(@next_nag.to_s)
		return true if time.nil?
		time < Time.now
	end
end

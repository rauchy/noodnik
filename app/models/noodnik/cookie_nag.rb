class CookieNag
	def initialize(topic, cookies)
		@next_nag = cookies[topic]
	end

	def due?
		!complete? && (brand_new? || expired?)
	end

	private

	def complete?
		@next_nag == 'complete'
	end

	def brand_new?
		@next_nag.nil?
	end

	def expired?
	  ActiveSupport::TimeZone['UTC'].parse(@next_nag.to_s) < Time.now 
	end
end

module Noodnik
  class Nag < ActiveRecord::Base
		def due?
			!(postponed? || completed?)
		end

		private

		def postponed?
			next_nag > Time.now
		end
  end

	class CookieNag
		def due?
			true
		end
	end
end

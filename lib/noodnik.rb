require "noodnik/engine"
require "noodnik/railtie"

module Noodnik
	mattr_accessor :current_user_id

	def self.setup
		yield self
	end	 
end

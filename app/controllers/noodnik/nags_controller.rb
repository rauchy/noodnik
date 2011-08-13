module Noodnik
	class NagsController < ApplicationController
		def postpone
			next_nag = params[:period].to_i.from_now
			topic = params[:topic]

			if user_id.present?
				Nag.create! user_id: user_id, topic: topic, next_nag: next_nag
			end

			render :nothing => true
		end

		def complete
			render :nothing => true
		end

		private

		def user_id
		  Noodnik.current_user_id.call
		end

	end
end

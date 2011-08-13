module Noodnik
	class NagsController < ApplicationController
		def postpone
			next_nag = params[:period].to_i.from_now

			if user_id.present?
				Nag.create! next_nag: next_nag, user_id: user_id
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

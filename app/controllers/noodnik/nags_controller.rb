module Noodnik
	class NagsController < ApplicationController
		def postpone
			next_nag = params[:period].to_i.from_now
			topic = params[:topic]

			if user_id.present?
				nag = find_or_create_nag(topic)
				nag.next_nag = next_nag
				nag.save
			else
				cookies[topic] = next_nag.to_s
			end

			render :nothing => true
		end

		def complete
			topic = params[:topic]

      if user_id.present?
				nag = find_or_create_nag(topic)
				nag.completed = true
				nag.save
			else
				cookies.delete topic
			end

			render :nothing => true
		end

		private

		def user_id
			Noodnik.current_user_id.call
		end

		def find_or_create_nag(topic)
			attr = { user_id: user_id, topic: topic }
			if Nag.exists? attr
				Nag.find :first, conditions: attr
			else
				Nag.new attr	
			end
		end
	end
end

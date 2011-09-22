Noodnik.setup do |config|
  config.current_user_id = lambda {  
		# Replace this block of comments with whatever code is needed in order to resolve the current user id at runtime.
		# For example, if you are using devise or sorcery, replace this entire block of comments with :
		#
		# 	current_user.id
	}
end

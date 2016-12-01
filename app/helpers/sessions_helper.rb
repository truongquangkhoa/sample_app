module SessionsHelper

	def log_in(user)
		sessions[:user_id] = user.id
	end
end

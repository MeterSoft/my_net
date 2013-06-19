def login_as(user)
  visit simulate_login_path(user)
end

def logout
  visit simulate_logout_path
end

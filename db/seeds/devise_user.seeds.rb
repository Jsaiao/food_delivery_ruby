after :roles, :restaurants  do
  puts '==> Creating the \'god user\'...'

# Deletes all existing records.
  User.delete_all

# Restarts ids to 1.
  ActiveRecord::Base.connection.reset_pk_sequence!('users')
  #ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'users'")


# Content.
  User.create(email: 'god@example.com', password: 'password', role: Role.find_by_key('god'), sign_in_count: 0,
              first_name: 'God', last_name: 'System', mother_last_name: 'User', username: 'divinity')
  User.create(email: 'res_admin@example.com', password: 'password', role: Role.find_by_key('res_admin'),
              sign_in_count: 0, restaurant_id: 1, first_name: 'Admin', last_name: 'Admin', mother_last_name: 'Admin',
              username: 'admin')
  User.create(email: 'client@example.com', password: 'password', role: Role.find_by_key('client'), sign_in_count: 0,
              first_name: 'Client', last_name: 'Client', mother_last_name: 'Client', username: 'client')
end

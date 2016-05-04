after :roles, :restaurants  do
  puts '==> Creating the \'god user\'...'

# Deletes all existing records.
  User.delete_all

# Restarts ids to 1.
  ActiveRecord::Base.connection.reset_pk_sequence!('users')
  #ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'users'")


# Content.
  User.create(email: 'god@example.com', password: 'password', role: Role.find_by_key('god'), sign_in_count: 0)
  User.create(email: 'res_admin@example.com', password: 'password', role: Role.find_by_key('res_admin'),
              sign_in_count: 0, restaurant_id: 1)
  User.create(email: 'client@example.com', password: 'password', role: Role.find_by_key('client'), sign_in_count: 0)
end

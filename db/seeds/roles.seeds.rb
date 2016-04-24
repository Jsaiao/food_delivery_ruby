puts '==> Filling the \'roles\' table...'

# Deletes all existing records.
Role.delete_all

# Restarts ids to 1.
ActiveRecord::Base.connection.reset_pk_sequence!('roles')
#ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'roles'")


# Content.
Role.create(name: 'God', key: 'god', description: 'Super administrador del sistema. Tiene acceso a todo y superpoderes.',
            scope: 0)
Role.create(name: 'Restaurant Admin', key: 'res_admin', description: 'Rol admin', scope: 1)
Role.create(name: 'Client', key: 'client', description: 'Rol default del sistema.', scope: 2)

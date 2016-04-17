puts '==> Filling the \'restaurants\' table...'

# Elimina todos los registros existentes.
Restaurant.delete_all

# Reinicia la secuencia de id a 1.
ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'restaurants'")

# Contenido.
res = Restaurant.create(name: 'McDonalds', description: 'The best hamburger seller!')

res.addresses.create(street: '601 10th Street', city: 'Texas', state: 'Texas', zipcode: '77565', phone_number: '409-948-4512')
res.addresses.create(street: 'SMALLSYS INC', city: 'TUCSON', state: 'Arizona', zipcode: '85705', phone_number: '')
res.addresses.create(street: '799 E DRAGRAM SUITE 5A', city: 'Tucson', state: 'Arizona', zipcode: '81654', phone_number: '')

res = Restaurant.create(name: 'Las Alitas', description: 'Yum yum yummy')

res.addresses.create(street: '300 BOYLSTON AVE E', city: 'SEATTLE', state: 'Washington', zipcode: '98102', phone_number: '343-123-5555')

res = Restaurant.create(name: 'Taco Bell', description: 'Taco')

res.addresses.create(street: '427 N Yarbrough Dr', city: 'El Paso', state: 'Texas', zipcode: '79915', phone_number: '915-236-1676')
res.addresses.create(street: '2103 N Mesa St', city: 'El Paso', state: 'Texas', zipcode: '79902', phone_number: '915-533-9161')

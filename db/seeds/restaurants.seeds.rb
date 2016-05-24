puts '==> Filling the \'restaurants\' table...'

# Elimina todos los registros existentes.
Restaurant.delete_all

# Reinicia la secuencia de id a 1.
#ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'restaurants'")
ActiveRecord::Base.connection.reset_pk_sequence!('restaurants')

# Contenido.
res1 = Restaurant.create(name: 'McDonalds', description: 'The best hamburger seller!')

res1.addresses.create(street: '601 10th Street', city: 'Texas', state: 'Texas', zipcode: '77565', phone_number: '409-948-4512')
res1.addresses.create(street: 'SMALLSYS INC', city: 'TUCSON', state: 'Arizona', zipcode: '85705', phone_number: '')
res1.addresses.create(street: '799 E DRAGRAM SUITE 5A', city: 'Tucson', state: 'Arizona', zipcode: '81654', phone_number: '')

res2 = Restaurant.create(name: 'Las Alitas', description: 'Yum yum yummy')

res2.addresses.create(street: '300 BOYLSTON AVE E', city: 'SEATTLE', state: 'Washington', zipcode: '98102', phone_number: '343-123-5555')

res3 = Restaurant.create(name: 'Taco Bell', description: 'Taco')

res3.addresses.create(street: '427 N Yarbrough Dr', city: 'El Paso', state: 'Texas', zipcode: '79915', phone_number: '915-236-1676')
res3.addresses.create(street: '2103 N Mesa St', city: 'El Paso', state: 'Texas', zipcode: '79902', phone_number: '915-533-9161')


res1.products.create(name: 'Big Mac', description: 'is big', price: 12.3, active: true, image: File.new("#{Rails.root}/utils/product_images/burger.png"))
res1.products.create(name: 'Quarter Pounder with Cheese', description: 'For big mouths', price: 14.65, active: true, image: File.new("#{Rails.root}/utils/product_images/burger2.png"))
res1.products.create(name: 'Bacon Clubhouse Burger', description: 'THE BEST', price: 10, active: false, image: File.new("#{Rails.root}/utils/product_images/burger3.png"))
res1.products.create(name: 'World Famous Fries', description: 'Potatooos', price: 8.80, active: true, image: File.new("#{Rails.root}/utils/product_images/potato.png"))

res2.products.create(name: 'The bittles', description: 'potatos and chicken', price: 15.22, active: true, image: File.new("#{Rails.root}/utils/product_images/bit1.png"))
res2.products.create(name: 'Buffalo Wing Sandwich', description: 'best burgar in the world', price: 13.20, active: true, image: File.new("#{Rails.root}/utils/product_images/chick.png"))
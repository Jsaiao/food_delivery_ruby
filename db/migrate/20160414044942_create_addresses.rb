class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :phone_number
      t.references :addressable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end

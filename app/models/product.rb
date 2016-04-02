# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  price         :float
#  restaurant_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Product < ActiveRecord::Base
  has_many :order_products
  belongs_to :restaurant
end

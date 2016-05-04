# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  reference_number :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Order < ActiveRecord::Base
  has_many :order_products
  belongs_to :address
  belongs_to :user

  after_create :get_cart_products

  def get_cart_products
    carts = self.user.carts
    carts.each do |cart|
      self.order_products.create(product_id: cart.product.id, price: cart.product.price, quantity: cart.quantity)
    end
    self.user.carts.destroy_all
  end
end

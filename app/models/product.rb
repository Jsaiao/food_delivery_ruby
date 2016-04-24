# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  price         :float
#  active        :boolean
#  restaurant_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Product < ActiveRecord::Base
  has_many :order_products
  has_attached_file :image, styles: { medium: '300x300>', thumb: '100x100>' }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  
  belongs_to :restaurant
end

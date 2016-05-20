# == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  name               :string
#  description        :text
#  price              :float
#  active             :boolean
#  restaurant_id      :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Product < ActiveRecord::Base
  has_many :order_products
  has_attached_file :image, styles: {medium: '300x300>', thumb: '100x100>'}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates_presence_of :name, :description, :price, :image ,:restaurant_id
  validates_numericality_of :price

  belongs_to :restaurant
end

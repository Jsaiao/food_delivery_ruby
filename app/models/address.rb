# == Schema Information
#
# Table name: addresses
#
#  id               :integer          not null, primary key
#  street           :string
#  city             :string
#  state            :string
#  zipcode          :string
#  phone_number     :string
#  addressable_id   :integer
#  addressable_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Address < ActiveRecord::Base
  validates_presence_of :street, :city, :state, :zipcode, :phone_number
  validates_numericality_of :zipcode, :phone_number
  belongs_to :addresable, polymorphic: true
  has_many :orders

  def get_address
    "#{self.street}, #{self.city}, #{self.state} #{self.zipcode}"
  end
end

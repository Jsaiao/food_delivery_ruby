# == Schema Information
#
# Table name: restaurants
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Restaurant < ActiveRecord::Base
  has_many :products
  has_many :addresses, as: :addressable

  accepts_nested_attributes_for :addresses, allow_destroy: true, reject_if: :all_blank
end

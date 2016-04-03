class Role < ActiveRecord::Base
  has_many :users
  has_many :permission_role, dependent: :destroy
  has_many :permissions, through: :permission_role

  enum scope: [:total, :site, :owner]

  validates_presence_of :name, :description, :scope
  validates_uniqueness_of :key, allow_blank: true
end

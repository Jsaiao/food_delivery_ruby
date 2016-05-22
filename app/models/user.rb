# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role_id                :integer
#  restaurant_id          :integer
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :username, :email, :first_name, :last_name, :mother_last_name

  attr_accessor :current_password

  has_many :conversations, foreign_key: :sender_id
  has_many :orders
  has_many :carts
  has_many :addresses, as: :addressable

  belongs_to :role
  belongs_to :restaurant
  delegate :name, :scope, :key, to: :role, prefix: true
  before_create :set_default_role

  accepts_nested_attributes_for :addresses, allow_destroy: true, reject_if: :all_blank

  def god?
    role and role.key == 'god'
  end

  def has_total_scope?
    role_scope == 'total'
  end

  def has_restaurant_scope?
    role_scope == 'restaurant'
  end

  def full_name
    "#{self.first_name} #{self.last_name} #{self.mother_last_name}"
  end

  private

  def set_default_role
    self.role ||= Role.find_by_key('client')
  end
end

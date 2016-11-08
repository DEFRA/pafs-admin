# frozen_string_literal: true
class User < PafsCore::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, #:registerable, :rememberable
         :recoverable, :trackable, :validatable, :timeoutable

  accepts_nested_attributes_for :user_areas
  paginates_per 10

  def active_for_authentication?
    admin?
  end

  def inactive_message
    "You must be an administrator to use this service"
  end

  def self.search(q)
    qq = "%#{q}%"
    table = arel_table
    User.includes(:areas).
      where(table[:first_name].matches(qq).
            or(table[:last_name].matches(qq)).
            or(table[:email].matches(qq)))
  end
end

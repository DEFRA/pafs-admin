# frozen_string_literal: true
class User < PafsCore::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, #:registerable, :rememberable
         :recoverable, :trackable, :validatable, :timeoutable

  validate :the_last_admin_isnt_disabled

  accepts_nested_attributes_for :user_areas
  paginates_per 10

  def active_for_authentication?
    admin? && !disabled?
  end

  def inactive_message
    "You must be an administrator to use this service" unless admin?
    "You must register for an account before using this service" if disabled?
  end

  def self.search(q)
    qq = "%#{q}%"
    table = arel_table
    User.includes(:areas).
      where(table[:first_name].matches(qq).
            or(table[:last_name].matches(qq)).
            or(table[:email].matches(qq)))
  end

  def self.admins
    where(admin: true)
  end

  private
  def the_last_admin_isnt_disabled
    if admin_changed?(to: false) || disabled_changed?(to: true)
      errors.add(:base,
                 "^No other administrators found. "\
                 "Please ensure at least one admin is present") unless
        User.where.not(id: id).admins.count.positive?
    end
  end
end

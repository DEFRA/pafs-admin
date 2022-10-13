# frozen_string_literal: true

class User < PafsCore::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable, :rememberable
         :recoverable, :trackable, :validatable, :timeoutable,
         :invitable, validate_on_invite: true

  validate :the_last_admin_isnt_disabled

  accepts_nested_attributes_for :user_areas
  paginates_per 10

  def active_for_authentication?
    admin? && !disabled?
  end

  def inactive_message
    if disabled?
      "You must register for an account before using this service"
    elsif !admin?
      "You must be an administrator to use this service"
    end
  end

  def self.search(term)
    qq = "%#{term}%"
    table = arel_table
    User.includes(:areas)
        .where(table[:first_name].matches(qq)
            .or(table[:last_name].matches(qq))
            .or(table[:email].matches(qq)))
  end

  def self.admins
    where(admin: true)
  end

  def self.active
    where(disabled: false)
  end

  private

  def the_last_admin_isnt_disabled
    return unless (admin_changed?(to: false) || disabled_changed?(to: true)) && !other_admins_exist?

    errors.add(:base, "^Ensure at least one adminstrator is available")
  end

  def other_admins_exist?
    User.where.not(id: id).admins.active.count.positive?
  end
end

# frozen_string_literal: true

module ApplicationHelper
  def area_label(index)
    index.zero? ? "Main Area" : "#{index.ordinalize} Area"
  end

  def determine_grouped_area(index, user)
    return grouped_areas if index.zero?
    return {} if user.primary_area.nil?

    user.primary_area.pso_area? ? pso_grouped_areas : rma_grouped_areas
  end

  def pso_grouped_areas
    {
      "PSOs" => PafsCore::Area.pso_areas.order(:name).map { |a| [a.name, a.id] }
    }
  end

  def rma_grouped_areas
    {
      "RMAs" => PafsCore::Area.rma_areas.order(:name).map { |a| [a.name, a.id] }
    }
  end

  def grouped_areas
    {
      "RMAs" => PafsCore::Area.rma_areas.order(:name).map { |a| [a.name, a.id] },
      "PSOs" => PafsCore::Area.pso_areas.order(:name).map { |a| [a.name, a.id] },
      "EA Areas" => PafsCore::Area.ea_areas.order(:name).map { |a| [a.name, a.id] }
    }
  end

  def revision_hash
    Rails.application.config.x.revision
  end

  def flag_for(bool)
    if bool
      "Y"
    else
      ""
    end
  end

  def yn_for(bool)
    !!bool ? "Y" : "N"
  end

  def date_or(date, txt)
    if date.nil?
      txt || ""
    else
      date.strftime("%-d %B %Y @ %H:%M:%S")
    end
  end

  def format_last_sign_in_date(date)
    date&.strftime("%d %B %Y")
  end

  def disabled_class(user)
    "disabled" if user.disabled?
  end

  def migrate_devise_errors_for(resource)
    # move flash messages and resource.errors to :base
    resource.errors.add(:base, flash[:alert]) if flash[:alert].present?

    if resource.errors[:password].present?
      resource.errors.full_messages_for(:password).each { |m| resource.errors.add(:base, m) }
    elsif resource.errors[:password_confirmation].present?
      # only add :password_confirmation errors if there are no :password errors
      resource.errors.full_messages_for(:password_confirmation).each { |m| resource.errors.add(:base, m) }
    end
    resource.errors.delete(:password)
    resource.errors.delete(:password_confirmation)
  end

  def upload_status(item_count)
    item_count.zero? ? "OK" : "Has errors"
  end

  def item_upload_status(error_count)
    error_count.zero? ? "OK" : "#{error_count} #{'error'.pluralize(error_count)}"
  end

  def grouped_authority_types
    PafsCore::Area.where(area_type: PafsCore::Area::AUTHORITY_AREA).select(:name, :identifier).map do |a|
      ["#{a.identifier} - #{a.name}", a.identifier]
    end
  end
end

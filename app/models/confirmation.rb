# frozen_string_literal: true
class Confirmation
  include ActiveModel::Model

  validate :confirm_has_been_set

  attr_reader :confirm

  # rubocop:disable Style/TrivialAccessors
  def confirm?
    @confirm
  end
  # rubocop:enable Style/TrivialAccessors

  def confirm=(value)
    @confirm = if value.nil?
                 false
               else
                 @confirm = (value == "Y" || value == "y" || value == "1" ||
                             value == "t")
               end
  end

  def confirm_has_been_set
    errors.add(:base, "^Confirm you understand the effect of opening the programme refresh") unless confirm?
  end
end

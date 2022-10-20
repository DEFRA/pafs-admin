# frozen_string_literal: true

class ProgrammeGenerationResetConfirmation
  include ActiveModel::Model

  validate :confirm_has_been_set

  attr_reader :confirm

  def confirm?
    @confirm
  end

  def confirm=(value)
    @confirm = if value.nil?
                 false
               else
                 @confirm = %w[Y y 1 t].include(value)
               end
  end

  def confirm_has_been_set
    return if confirm?

    errors.add(:base, "^You must confirm that by continuing," \
                      "you understand that ALL failed proposals will be reset")
  end
end

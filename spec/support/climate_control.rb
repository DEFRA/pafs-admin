# frozen_string_literal: true

module ClimateControlHelper
  def with_modified_env(options, &)
    ClimateControl.modify(options, &)
  end
end

RSpec.configure do |config|
  config.include ClimateControlHelper
end

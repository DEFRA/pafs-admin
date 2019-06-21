# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    PafsCore::ReferenceCounter.seed_counters
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :organisation, class: "Organisation" do
    name { Faker::Lorem.sentence }

    trait :rma do
      area_type { Organisation::RMA_AREA }
      sub_type { PafsCore::Area.authorities.first&.identifier || create(:authority).identifier }
      identifier { Faker::Lorem.characters(number: 10) }

      parent { PafsCore::Area.pso_areas.first || create(:organisation, :pso) }
    end

    trait :ea do
      area_type { Organisation::EA_AREA }

      parent { PafsCore::Area.country || create(:country) }
    end

    trait :pso do
      area_type { Organisation::PSO_AREA }

      parent { PafsCore::Area.ea_areas.first || create(:organisation, :ea) }
    end

    trait :authority do
      area_type { Organisation::AUTHORITY }
      identifier { Faker::Lorem.characters(number: 10) }
    end
  end
end

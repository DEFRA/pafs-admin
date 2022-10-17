# frozen_string_literal: true

FactoryBot.define do
  factory :admin, class: "User" do
    first_name { "Admin" }
    last_name { "User" }
    email { "admin@example.com" }
    password { "Secr3tP@ssw0rd" }
    admin { true }

    trait :ea do
      after(:create) do |user|
        area = PafsCore::Area.ea_areas.first || create(:ea_area)
        user.user_areas.create(area: area, primary: true)
      end
    end

    trait :pso do
      after(:create) do |user|
        area = PafsCore::Area.pso_areas.first || create(:pso_area)
        user.user_areas.create(area: area, primary: true)
      end
    end

    trait :rma do
      after(:create) do |user|
        area = PafsCore::Area.rma_areas.first || create(:rma_area)
        user.user_areas.create(area: area, primary: true)
      end
    end
  end
end

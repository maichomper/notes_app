# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    sequence(:name, 1) { |n| "note#{n}" }
    folder
  end
end

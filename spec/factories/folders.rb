# frozen_string_literal: true

FactoryBot.define do
  factory :folder do
    sequence(:name, 1) { |n| "folder#{n}" }
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Note, type: :model do
  # Test all model's attributes
  it { should respond_to(:name) }
  it { should respond_to(:folder_id) }
  # Test validations
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  # Test associations
  it { should belong_to(:folder) }
end

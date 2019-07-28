# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :folder

  validates :name, presence: true, uniqueness: true
end

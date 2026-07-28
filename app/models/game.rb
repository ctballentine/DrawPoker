class Game < ApplicationRecord
  # Returns only games that have a winner
  scope :completed, -> { where.not(winner: nil) }
end

class Event < ApplicationRecord
    validates :number, presence: true, numericality: { only_integer: true }
    validates :state, presence: true, inclusion: { in: %w( open closed ) }
end

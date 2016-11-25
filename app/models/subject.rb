class Subject < ApplicationRecord
	has_many :visits
	validates :identifier, presence: true
	validates :condition, presence: true
end

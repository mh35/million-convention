class IdolThread < ApplicationRecord
  belongs_to :idol
  has_many :thread_responses
end

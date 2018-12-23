class User < ApplicationRecord
  has_many :thread_responses
  has_many :reports
end

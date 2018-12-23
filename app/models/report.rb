class Report < ApplicationRecord
  belongs_to :thread_response
  belongs_to :user
end

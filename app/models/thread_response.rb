class ThreadResponse < ApplicationRecord
  belongs_to :idol_thread
  belongs_to :user
  has_many :reports
end

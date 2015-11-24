class Goal < ActiveRecord::Base
  validates :title, :description, :visibility, :status, :user_id, presence: true

  belongs_to :user

end

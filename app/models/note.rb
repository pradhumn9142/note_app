class Note < ApplicationRecord
    belongs_to :user

    validates :title, presence: true
    validates :content, presence: true
    validates :is_pinned, inclusion: { in: [ true, false ] }
end

class Comment < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :user
  belongs_to :state
  belongs_to :previous_state, class_name: "State"

  attr_accessor :tag_names

  validates :text, presence: true

  before_create :set_previous_state
  after_create :set_ticket_state
  after_create :associate_tag_with_ticket
  after_create :add_user_to_watchers

  private

    def set_previous_state
      self.previous_state = ticket.state
    end

    def set_ticket_state
      self.ticket.state = self.state
      self.ticket.save!
    end

    def associate_tag_with_ticket
      if tag_names
        self.ticket.tags += Tag.create_tags tag_names
        self.ticket.save
      end
    end

    def add_user_to_watchers
      ticket.watchers << user
    end
end

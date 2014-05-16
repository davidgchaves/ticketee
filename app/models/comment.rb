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
      previous_state = ticket.state
    end

    def set_ticket_state
      ticket.state = state
      ticket.save!
    end

    def associate_tag_with_ticket
      if tag_names
        ticket.tags += create_tags
        ticket.save
      end
    end

    def add_user_to_watchers
      ticket.watchers << user
    end

    def create_tags
      tag_names.split(" ").map { |tag_name| Tag.find_or_create_by name: tag_name }
    end
end

class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :state

  has_many :assets
  has_many :comments
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :watchers, join_table: "ticket_watchers", class_name: "User"

  attr_accessor :tag_names

  accepts_nested_attributes_for :assets

  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10 }

  before_create :associate_tags
  after_create :creator_watches_me

  def self.search(query)
    search_terms_by_criteria = {}
    query.split(" ")
      .inject(search_terms_by_criteria) do |acc, q|
        search_criteria, search_term = q.split ":"
        acc[search_criteria] = search_term
      end

    relation = []

    if search_terms_by_criteria.has_key? "tag"
      relation = joins(:tags).where "tags.name = ?", search_terms_by_criteria["tag"]
    end

    if search_terms_by_criteria.has_key? "state"
      relation = joins(:state).where "states.name = ?", search_terms_by_criteria["state"]
    end

    relation
  end

  private

    def associate_tags
      if tag_names
        tag_names.split(" ").each do |tag_name|
          self.tags << Tag.find_or_create_by(name: tag_name)
        end
      end
    end

    def creator_watches_me
      add_user_to_watchers if user
    end

    def add_user_to_watchers
      self.watchers << user unless self.watchers.include? user
    end
end

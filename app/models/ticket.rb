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
  before_create :set_default_state
  after_create :add_creator_to_watchers

  def self.search(query)
    search_terms_by_criteria = extract_search_terms_from query

    relation = []

    if search_terms_by_criteria.has_key? "tag"
      relation = joins(:tags).where "tags.name = ?", search_terms_by_criteria["tag"]
    end

    if search_terms_by_criteria.has_key? "state"
      relation = joins(:state).where "states.name = ?", search_terms_by_criteria["state"]
    end

    relation
  end

  def add_to_watchers(user)
    self.watchers << user unless self.watchers.include? user
  end

  def remove_from_watchers(user)
    self.watchers -= [user]
  end

  private

    def associate_tags
      self.tags += Tag.create_tags(tag_names) if tag_names
    end

    def set_default_state
      self.state = State.where(name: "New").first
    end

    def add_creator_to_watchers
      add_to_watchers user if user
    end

    def self.extract_search_terms_from(query)
      search_terms = {}
      query.split(" ").inject(search_terms) do |acc, q|
        search_criteria, search_term = q.split ":"
        acc[search_criteria] = search_term
      end
      search_terms
    end
end

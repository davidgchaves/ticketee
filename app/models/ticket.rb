class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :state

  has_many :assets
  has_many :comments
  has_and_belongs_to_many :tags

  attr_accessor :tag_names

  accepts_nested_attributes_for :assets

  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 10 }

  before_create :associate_tags

  private

    def associate_tags
      if tag_names
        tag_names.split(" ").each do |tag_name|
          self.tags << Tag.find_or_create_by(name: tag_name)
        end
      end
    end
end

class Tag < ActiveRecord::Base
  def self.create_tags(tag_names)
    tag_names.split(" ").map { |tag_name| self.find_or_create_by name: tag_name }
  end
end

class State < ActiveRecord::Base
  validates :name, presence: true

  def default!
    State.find_by(default: true).try(:update!, default: false)
    self.update! default: true
  end

  def to_s
    name
  end
end

class Asset < ActiveRecord::Base
  mount_uploader :asset, AssetUploader

  belongs_to :ticket

  before_save :update_content_type

  private

    def update_content_type
      self.content_type = asset.file.content_type if asset.present? && asset_changed?
    end
end

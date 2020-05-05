class ProjectImage < ApplicationRecord
  belongs_to :partner_project
  mount_uploader :attachment, ProjectImageUploader
  validates_presence_of :attachment
end

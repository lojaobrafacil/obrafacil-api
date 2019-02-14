class Report < ApplicationRecord
  validates_presence_of :name
  mount_uploader :attachment, ReportFileUploader
end

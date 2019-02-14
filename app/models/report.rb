class Report < ApplicationRecord
  belongs_to :employee
  validates_presence_of :name
  mount_uploader :attachment, ReportFileUploader
end

class CreateEmployeePermissionsAssociation < ActiveRecord::Migration[5.1]
  def change
    create_table :employees_permissions, id: false do |t|
      t.belongs_to :employee, index: true
      t.belongs_to :permission, index: true
    end
  end
end

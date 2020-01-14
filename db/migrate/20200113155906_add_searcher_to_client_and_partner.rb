class AddSearcherToClientAndPartner < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :searcher, :string, :index => true
    add_column :partners, :searcher, :string, :index => true
  end
end

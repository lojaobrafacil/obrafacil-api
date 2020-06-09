class AddSearcherToCities < ActiveRecord::Migration[5.2]
  def change
    add_column :cities, :searcher, :string
  end
end

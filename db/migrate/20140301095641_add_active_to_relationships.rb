class AddActiveToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :active, :boolean, default: false
    add_index :relationships, :active
  end
end

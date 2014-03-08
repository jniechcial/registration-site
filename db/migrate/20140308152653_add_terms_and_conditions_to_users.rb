class AddTermsAndConditionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :terms, :boolean
    add_column :users, :agreement, :boolean
  end
end

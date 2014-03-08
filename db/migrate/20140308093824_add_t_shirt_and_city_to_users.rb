class AddTShirtAndCityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :city, :string
    add_column :users, :tshirt, :string
  end
end

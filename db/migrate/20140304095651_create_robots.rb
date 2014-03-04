class CreateRobots < ActiveRecord::Migration
  def change
    create_table :robots do |t|
      t.string :name
      t.integer :team_id
      t.integer :competition_id

      t.timestamps
    end
  end
end

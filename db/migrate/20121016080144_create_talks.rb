class CreateTalks < ActiveRecord::Migration
  def change
    create_table :talks do |t|
      t.text :log

      t.timestamps
    end
  end
end

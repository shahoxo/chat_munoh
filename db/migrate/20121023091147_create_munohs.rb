class CreateMunohs < ActiveRecord::Migration
  def change
    create_table :munohs do |t|
      t.string :name, null: false
      t.string :twitter_name

      t.timestamps
    end
  end
end

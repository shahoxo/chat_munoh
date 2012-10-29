class CreatePhrases < ActiveRecord::Migration
  def change
    create_table :phrases do |t|
      t.string :keyword
      t.text :reply

      t.timestamps
    end
  end
end

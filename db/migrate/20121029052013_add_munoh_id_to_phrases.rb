class AddMunohIdToPhrases < ActiveRecord::Migration
  def change
    add_column :phrases, :munoh_id, :integer
  end
end

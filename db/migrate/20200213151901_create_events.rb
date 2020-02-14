class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :number
      t.string :state

      t.timestamps
    end
  end
end

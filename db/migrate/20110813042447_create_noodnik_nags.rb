class CreateNoodnikNags < ActiveRecord::Migration
  def change
    create_table :noodnik_nags do |t|
      t.integer :id
      t.datetime :next_nag
      t.boolean :completed

      t.timestamps
    end
  end
end

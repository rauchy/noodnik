class AddTopicToNags < ActiveRecord::Migration
  def change
    add_column :noodnik_nags, :topic, :string
  end
end

class AddUserIdToNags < ActiveRecord::Migration
  def change
		add_column :noodnik_nags, :user_id, :integer
  end
end

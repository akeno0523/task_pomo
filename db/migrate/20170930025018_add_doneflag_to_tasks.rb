class AddDoneflagToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :doneflag, :boolean , default: false, null: false
  end
end

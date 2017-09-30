class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
      t.string :task_id
      t.integer :achievment
      t.time :act_time
      t.string :act_date

      t.timestamps
    end
  end
end

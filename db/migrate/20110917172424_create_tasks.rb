class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :content
      t.integer :user_id
      t.datetime :due_date
      t.string :category
      t.string :priority
      t.string :status

      t.timestamps
    end
    add_index :tasks, [:user_id, :created_at] 
    add_index :tasks, [:due_date, :category, :priority, :status]
  end

  def self.down
    drop_table :tasks
  end
end

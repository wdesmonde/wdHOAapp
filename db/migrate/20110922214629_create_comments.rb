class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :user_id
      t.string :content
      t.references :task

      t.timestamps
    end
      add_index :comments, :task_id
  end

  def self.down
    drop_table :comments
  end
end

class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
    	t.string :title
    	t.integer :user_id
    	t.text :introduction
    	t.string :avatar
      t.string :avatar_file_name
      t.string :avatar_content_type
      t.string :avatar_file_size
    	t.string :goals
    	t.string :category_id
    	t.datetime :start_at
    	t.datetime :end_at
      t.timestamps
    end
  end
end

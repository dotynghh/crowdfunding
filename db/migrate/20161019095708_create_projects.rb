class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
    	t.string :title
    	t.integer :user_id
    	t.text :introduction
    	t.string :avatar
    	t.string :goals
    	t.string :category_id
    	t.datetime :start_at
    	t.datetime :end_at
      t.timestamps
    end
  end
end

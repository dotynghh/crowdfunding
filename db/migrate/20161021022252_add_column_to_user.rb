class AddColumnToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :avatar_file_size, :string
    add_column :users, :avatar_content_type, :string
    add_column :users, :avatar_file_name, :string
  end
end

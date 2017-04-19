class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.string :address_type
      t.string :contact_name, :cellphone, :address, :zipcode
      t.timestamps
    end
    add_column :users, :default_address_id, :integer
  end
end

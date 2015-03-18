class AddAttributeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean
    add_column :users, :name, :string
    add_column :users, :avatar, :string
  end
end

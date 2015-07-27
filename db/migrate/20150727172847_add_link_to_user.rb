class AddLinkToUser < ActiveRecord::Migration
  def change
    add_column :users, :link, :string
    add_column :users, :phonenumber, :string
  end
end

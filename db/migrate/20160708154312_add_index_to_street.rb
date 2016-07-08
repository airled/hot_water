class AddIndexToStreet < ActiveRecord::Migration
  def change
    add_index :addresses, :street
  end
end

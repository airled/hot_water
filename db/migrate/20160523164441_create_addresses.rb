class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :offdate
      t.string :street
      t.string :house
      t.timestamps null: false
    end
  end
end

class CreateOffdates < ActiveRecord::Migration
  def change
    create_table :offdates do |t|
      t.string :date
      t.timestamps null: false
    end
  end
end

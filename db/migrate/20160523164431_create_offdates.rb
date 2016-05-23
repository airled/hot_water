class CreateOffdates < ActiveRecord::Migration
  def change
    create_table :offdates do |t|

      t.timestamps null: false
    end
  end
end

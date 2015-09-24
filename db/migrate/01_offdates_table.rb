Sequel.migration do
  up do
    create_table :offdates do
      primary_key :id
      String :offdate
      index :offdate
    end
  end
  down do
    drop_table(:offdates)
  end
end  
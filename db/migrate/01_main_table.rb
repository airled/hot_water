Sequel.migration do
  up do
    create_table :records do
      primary_key :id
      String :date
      String :address
    end
  end
  down do
    drop_table(:records)
  end
end  
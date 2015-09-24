Sequel.migration do
  up do
    create_table :dates do
      primary_key :id
      String :date
      index :date
    end
  end
  down do
    drop_table(:dates)
  end
end  
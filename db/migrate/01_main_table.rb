Sequel.migration do
  up do
    create_table :dates do
      primary_key :id
      String :date
      String :address
    end
  end
  down do
    drop_table(:dates)
  end
end  
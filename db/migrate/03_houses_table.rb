Sequel.migration do
  up do
    create_table :houses do
      primary_key :id
      Integer :street_id
      String :housenumber
      index :housenumber
    end
  end
  down do
    drop_table(:houses)
  end
end  
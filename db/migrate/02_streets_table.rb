Sequel.migration do
  up do
    create_table :streets do
      primary_key :id
      Integer :offdate_id
      String :streetname
      index :streetname
    end
  end
  down do
    drop_table(:streets)
  end
end  
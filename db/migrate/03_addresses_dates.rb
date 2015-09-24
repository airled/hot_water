Sequel.migration do
  up do
    create_table :addresses_dates do
      primary_key :id
      Integer :address_id
      Integer :date_id
    end
  end
  down do
    drop_table(:addresses_dates)
  end
end   
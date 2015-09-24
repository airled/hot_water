Sequel.migration do
  up do
    create_table :addresses_offdates do
      primary_key :id
      Integer :address_id
      Integer :offdate_id
    end
  end
  down do
    drop_table(:addresses_offdates)
  end
end   
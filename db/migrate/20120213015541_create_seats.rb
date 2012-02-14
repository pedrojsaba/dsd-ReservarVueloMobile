class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.integer :id_asiento
      t.integer :numero
      t.string :posicion
      t.integer :flight_id

      t.timestamps
    end
  end
end

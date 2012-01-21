class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.integer :numero
      t.string :posicion
      t.string :vuelo
      t.boolean :estado

      t.timestamps
    end
  end
end

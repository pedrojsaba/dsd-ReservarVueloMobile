class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.string :codigo
      t.string :aerolinea
      t.datetime :salida
      t.datetime :llegada
      t.string :ciudad
      t.boolean :estado

      t.timestamps
    end
  end
end

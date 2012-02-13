class CreatePassengers < ActiveRecord::Migration
  def change
    create_table :passengers do |t|
      t.string :user
      t.string :password
      t.string :password_reply
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end
  end
end

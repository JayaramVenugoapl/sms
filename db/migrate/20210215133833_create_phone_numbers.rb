class CreatePhoneNumbers < ActiveRecord::Migration[6.1]
  def change
    create_table :phone_numbers do |t|
      t.integer :number
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end

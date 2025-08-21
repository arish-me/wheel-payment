class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :milestone, null: false, foreign_key: true
      t.string :payment_provider
      t.string :provider_id
      t.integer :status
      t.integer :fee_cents
      t.integer :net_amount_cents

      t.timestamps
    end
  end
end

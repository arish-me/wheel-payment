class CreateDisputes < ActiveRecord::Migration[8.0]
  def change
    create_table :disputes do |t|
      t.references :milestone, null: false, foreign_key: true
      t.references :raised_by, null: false, foreign_key: { to_table: :users }
      t.text :reason
      t.integer :status

      t.timestamps
    end
  end
end

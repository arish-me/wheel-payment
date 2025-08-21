class CreateMilestones < ActiveRecord::Migration[8.0]
  def change
    create_table :milestones do |t|
      t.string :title
      t.text :description
      t.integer :amount_cents
      t.string :currency
      t.integer :status
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end

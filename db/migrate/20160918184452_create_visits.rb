class CreateVisits < ActiveRecord::Migration[5.0]
  def change
    create_table :visits do |t|
      t.string :candidate
      t.string :condition
      t.boolean :lure
      t.integer :code
      t.integer :index
      t.integer :rand_index
      t.integer :time_spent
      t.integer :subject_id

      t.timestamps
    end
  end
end

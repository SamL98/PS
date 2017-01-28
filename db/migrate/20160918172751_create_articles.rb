class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :candidate
      t.string :title
      t.string :text
      t.integer :index
      t.integer :rand_index
      t.string :condition
      t.integer :template

      t.timestamps
    end
  end
end

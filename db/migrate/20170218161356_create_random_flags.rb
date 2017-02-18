class CreateRandomFlags < ActiveRecord::Migration[5.0]
  def change
    create_table :random_flags do |t|
      t.boolean :flag
      t.string :ordering
      t.timestamps
    end
  end
end

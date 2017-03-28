class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
      t.text :ticker

      t.timestamps
    end
  end
end

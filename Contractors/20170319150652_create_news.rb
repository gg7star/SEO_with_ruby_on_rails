class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
      t.string :ticker
      t.string :url
      t.date :pubDate
      t.string :subject
      t.longtext :rawText
      t.timestamps
    end
  end
end
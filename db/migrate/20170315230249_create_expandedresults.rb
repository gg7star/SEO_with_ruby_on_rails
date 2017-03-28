class CreateExpandedresults < ActiveRecord::Migration[5.0]
  def change
    create_table :expandedresults do |t|
      t.string :ticker
      t.string :country
      t.datetime :pubDate
      t.string :url
      t.string :title
      t.text :rawText
      t.float :sentimentScore
      t.float :targetedScore
      t.string :targeted_type

      t.timestamps
    end
  end
end

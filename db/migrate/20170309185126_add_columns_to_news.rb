class AddColumnsToNews < ActiveRecord::Migration[5.0]
  def change
    add_column :news, :pubDate, :datetime
    add_column :news, :url, :string
    add_column :news, :subject, :text
    add_column :news, :rawText, :longtext
    add_column :news, :keyword_score, :real
  end
end

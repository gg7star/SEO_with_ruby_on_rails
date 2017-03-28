class ChangePubDate < ActiveRecord::Migration[5.0]
  def change
    add_column :targeted, :pubDate, :datetime
    rename_table :targeted, :targets
  end
end

class AddColumnToTargets < ActiveRecord::Migration[5.0]
  def change
    add_column :targets, :targetedKeywords, :string
  end
end

class AddMovingAvgColumnToTargets < ActiveRecord::Migration[5.0]
  def change
    add_column :targets, :MovAvg, :float
  end
end

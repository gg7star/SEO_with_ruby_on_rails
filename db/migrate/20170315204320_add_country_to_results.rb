class AddCountryToResults < ActiveRecord::Migration[5.0]
  def change
    add_column :results, :country, :string
  end
end

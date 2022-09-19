class AddModelToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :model, :string
  end
end

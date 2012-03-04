class UpdateLineItemColumnName < ActiveRecord::Migration
  def change
    rename_column :line_items, :card_id, :cart_id
  end
end

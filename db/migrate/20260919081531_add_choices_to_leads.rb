class AddChoicesToLeads < ActiveRecord::Migration[8.1]
  def change
    add_column :leads, :choices, :text
  end
end

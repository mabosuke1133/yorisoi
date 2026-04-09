class AddBodyToConsultations < ActiveRecord::Migration[6.1]
  def change
    add_column :consultations, :body, :text
  end
end

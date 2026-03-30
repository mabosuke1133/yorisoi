class AddIsConsultationToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :is_consultation, :boolean
  end
end

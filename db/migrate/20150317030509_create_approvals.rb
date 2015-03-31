class CreateApprovals < ActiveRecord::Migration
  def change
    create_table :approvals do |t|
      t.references :exam, index: true
      t.references :question, index: true
      t.boolean :correct

      t.timestamps null: false
    end
    add_foreign_key :approvals, :exams
    add_foreign_key :approvals, :questions
  end
end

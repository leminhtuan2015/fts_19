class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :exam, index: true
      t.references :question, index: true
      t.references :answer, index: true

      t.timestamps null: false
    end
    add_foreign_key :responses, :exams
    add_foreign_key :responses, :questions
    add_foreign_key :responses, :answers
  end
end

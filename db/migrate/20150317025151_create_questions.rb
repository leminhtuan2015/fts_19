class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :content
      t.references :subject, index: true

      t.timestamps null: false
    end
    add_foreign_key :questions, :subjects
  end
end

class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.integer :mark
      t.datetime :time
      t.references :user, index: true
      t.references :subject, index: true

      t.timestamps null: false
    end
    add_foreign_key :exams, :users
    add_foreign_key :exams, :subjects
  end
end

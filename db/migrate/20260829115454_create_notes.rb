class CreateNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :content
      t.boolean :is_pinned

      t.timestamps
    end
  end
end

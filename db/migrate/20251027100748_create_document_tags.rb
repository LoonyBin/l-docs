class CreateDocumentTags < ActiveRecord::Migration[8.1]
  def change
    create_table :document_tags do |t|
      t.integer :document_id, null: false
      t.integer :tag_id, null: false
      t.boolean :ai_generated, default: false
      t.float :confidence

      t.timestamps
    end

    add_index :document_tags, [ :document_id, :tag_id ], unique: true
    add_index :document_tags, :tag_id
  end
end

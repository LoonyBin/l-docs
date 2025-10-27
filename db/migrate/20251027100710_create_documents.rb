class CreateDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :documents do |t|
      t.string :title, null: false
      t.text :description
      t.string :document_type
      t.string :variant_type
      t.integer :parent_document_id
      t.jsonb :metadata, default: {}
      t.float :ai_confidence
      t.string :ai_processing_status, default: "pending"

      t.timestamps
    end

    add_index :documents, :parent_document_id
    add_index :documents, :document_type
    add_index :documents, :ai_processing_status
    add_index :documents, :metadata, using: :gin
  end
end

class CreateDocumentVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :document_versions do |t|
      t.integer :document_id, null: false
      t.integer :version_number, null: false
      t.string :version_name
      t.text :notes
      t.jsonb :file_metadata, default: {}
      t.integer :upload_batch_id

      t.timestamps
    end

    add_index :document_versions, :document_id
    add_index :document_versions, [ :document_id, :version_number ], unique: true
    add_index :document_versions, :upload_batch_id
  end
end

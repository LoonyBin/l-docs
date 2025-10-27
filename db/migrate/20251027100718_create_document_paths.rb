class CreateDocumentPaths < ActiveRecord::Migration[8.1]
  def change
    create_table :document_paths do |t|
      t.integer :document_id, null: false
      t.string :path, null: false
      t.integer :position, default: 0

      t.timestamps
    end

    add_index :document_paths, :document_id
    add_index :document_paths, :path, unique: true
  end
end

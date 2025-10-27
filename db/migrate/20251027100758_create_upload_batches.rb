class CreateUploadBatches < ActiveRecord::Migration[8.1]
  def change
    create_table :upload_batches do |t|
      t.string :status, null: false, default: "uploading"
      t.integer :total_files, default: 0
      t.integer :processed_files, default: 0
      t.jsonb :ai_context, default: {}

      t.timestamps
    end

    add_index :upload_batches, :status
  end
end

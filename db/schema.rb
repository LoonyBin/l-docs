# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_10_27_100758) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "document_paths", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "document_id", null: false
    t.string "path", null: false
    t.integer "position", default: 0
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_document_paths_on_document_id"
    t.index ["path"], name: "index_document_paths_on_path", unique: true
  end

  create_table "document_tags", force: :cascade do |t|
    t.boolean "ai_generated", default: false
    t.float "confidence"
    t.datetime "created_at", null: false
    t.integer "document_id", null: false
    t.integer "tag_id", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id", "tag_id"], name: "index_document_tags_on_document_id_and_tag_id", unique: true
    t.index ["tag_id"], name: "index_document_tags_on_tag_id"
  end

  create_table "document_versions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "document_id", null: false
    t.jsonb "file_metadata", default: {}
    t.text "notes"
    t.datetime "updated_at", null: false
    t.integer "upload_batch_id"
    t.string "version_name"
    t.integer "version_number", null: false
    t.index ["document_id", "version_number"], name: "index_document_versions_on_document_id_and_version_number", unique: true
    t.index ["document_id"], name: "index_document_versions_on_document_id"
    t.index ["upload_batch_id"], name: "index_document_versions_on_upload_batch_id"
  end

  create_table "documents", force: :cascade do |t|
    t.float "ai_confidence"
    t.string "ai_processing_status", default: "pending"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "document_type"
    t.jsonb "metadata", default: {}
    t.integer "parent_document_id"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "variant_type"
    t.index ["ai_processing_status"], name: "index_documents_on_ai_processing_status"
    t.index ["document_type"], name: "index_documents_on_document_type"
    t.index ["metadata"], name: "index_documents_on_metadata", using: :gin
    t.index ["parent_document_id"], name: "index_documents_on_parent_document_id"
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key"
    t.string "name", null: false
    t.string "tag_type", null: false
    t.datetime "updated_at", null: false
    t.integer "usage_count", default: 0
    t.string "value"
    t.index ["name"], name: "index_tags_on_name", unique: true
    t.index ["tag_type", "key", "value"], name: "index_tags_on_tag_type_and_key_and_value"
    t.index ["tag_type"], name: "index_tags_on_tag_type"
  end

  create_table "upload_batches", force: :cascade do |t|
    t.jsonb "ai_context", default: {}
    t.datetime "created_at", null: false
    t.integer "processed_files", default: 0
    t.string "status", default: "uploading", null: false
    t.integer "total_files", default: 0
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_upload_batches_on_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end

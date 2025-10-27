class CreateTags < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :tag_type, null: false
      t.string :key
      t.string :value
      t.integer :usage_count, default: 0

      t.timestamps
    end

    add_index :tags, :name, unique: true
    add_index :tags, :tag_type
    add_index :tags, [ :tag_type, :key, :value ]
  end
end

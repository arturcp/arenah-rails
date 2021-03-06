class CreateCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :characters do |t|
      t.integer :user_id, index: true, foreign_key: true, null: false
      t.integer :game_id, index: true, foreign_key: true
      t.string :name, limit: 100
      t.string :avatar
      t.integer :character_type, default: 0, null: false
      t.string :signature
      t.integer :status, default: 1, null: false
      t.integer :gender, default: 0, null: false
      t.integer :sheet_mode, default: 0, null: false
      t.datetime :last_post_date
      t.integer :post_count, default: 0
      t.string :slug, null: false
      t.jsonb :sheet, default: {}, null: false

      t.timestamps null: false
    end

    add_index :characters, :slug, unique: true
    add_index  :characters, :sheet, using: :gin
  end
end

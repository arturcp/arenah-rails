class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      #t.string :email, null: false
      #t.string :password, null: false
      t.string :legacy_password
      t.string :name, null: false, limit: 100
      #t.string :nickname, null: false
      #t.string :secret_question
      #t.string :secret_answer
      t.boolean :active, default: false
      #t.string :activation_code
      t.string :slug, null: false

      t.timestamps null: false
    end

    add_index :users, :slug, :unique => true
  end
end

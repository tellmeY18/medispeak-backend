class MigrateFields < ActiveRecord::Migration[8.0]
  def change
    create_table :webapps do |t|
      t.string :title
      t.string :fqdn
      t.boolean :autofill
      t.references :user, foreign_key: true
      t.timestamps
    end

    create_table :templates do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.boolean :archived, null: false, default: false
      t.timestamps
    end

    create_table :pages do |t|
      t.references :webapp, foreign_key: true
      t.references :template, null: false, foreign_key: true
      t.string :name
      t.string :prompt
      t.timestamps
    end

    create_table :form_fields do |t|
      t.string :title
      t.string :description
      t.references :page, null: false, foreign_key: true
      t.jsonb :metadata, default: {}, null: false
      t.timestamps
    end

    create_table :transcriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :page, null: false, foreign_key: true
      t.jsonb :ai_response, null: false, default: {}
      t.text :transcription_text
      t.string :status, null: false, default: "pending"
      t.integer :duration, default: 0
      t.integer :prompt_tokens, default: 0
      t.integer :completion_tokens, default: 0
      t.integer :total_tokens, default: 0
      t.jsonb :context, default: {}, null: false
      t.timestamps
    end

    create_table :domains do |t|
      t.references :template, null: false, foreign_key: true, index: true
      t.string :fqdn, null: false
      t.boolean :archived, null: false, default: false
      t.timestamps
    end
  end
end

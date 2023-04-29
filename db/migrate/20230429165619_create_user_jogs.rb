class CreateUserJogs < ActiveRecord::Migration[7.0]
  def change
    create_table :user_jogs do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.date :jogging_date
      t.time :jogging_time
      t.float :distance
      t.integer :created_by
      t.boolean :deleted, default: false
      t.integer :deleted_by
      t.datetime :deleted_at

      t.timestamps
    end
  end
end

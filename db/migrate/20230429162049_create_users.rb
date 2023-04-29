class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.integer :user_group_id, default: 3
      t.boolean :status, default: true
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end

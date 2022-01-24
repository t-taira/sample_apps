class CreateUserNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :user_notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :notification_type, null: false
      t.text :message, null: false

      t.timestamps
    end
  end
end

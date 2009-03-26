class CreateConversation < ActiveRecord::Migration
  def self.up
    create_table :conversations, :force => true do |t|
      t.integer :handler_id
      t.integer :user_id
      t.string :state
      t.datetime :completed_at
      t.timestamps
    end

    create_table :conversation_messages, :force => true do |t|
      t.integer :conversation_id
      t.integer :inbox_id
    end
  end

  def self.down
    drop_table :conversations
  end
end

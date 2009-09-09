class CreateInbox < ActiveRecord::Migration
  def self.up
    create_table :inbox, :force => true do |t|
      t.string :text
      t.string :number
      t.integer :reply_to
      t.integer :gateway_id
      t.string :receiver
      t.datetime :sent_at
      t.datetime :processed_at
      t.boolean :handled
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :inbox
  end
end

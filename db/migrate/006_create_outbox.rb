class CreateOutbox < ActiveRecord::Migration
  def self.up
    create_table :outbox, :force => true do |t|
      t.string :text
      t.string :number
      t.integer :reply_to
      t.integer :gateway_id
      t.boolean :sent
      t.datetime :sent_at
      t.boolean :receipt
      t.datetime :received_at
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :outbox
  end
end

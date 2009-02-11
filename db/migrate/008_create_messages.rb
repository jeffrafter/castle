class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages, :force => true do |t|
      t.string :message
      t.string :number
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end

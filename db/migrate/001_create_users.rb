class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string   :email
      t.boolean  :email_confirmed, :default => false, :null => false
      t.string   :encrypted_password, :limit => 40
      t.string   :salt, :limit => 40
      t.string   :token, :limit => 128
      t.datetime :token_expires_at
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.string   :number
      t.boolean  :number_confirmed, :default => false, :null => false      
      t.boolean  :active, :default => true, :null => false
    end

    add_index :users, [:id, :token]
    add_index :users, [:email, :encrypted_password]
    add_index :users, [:id, :salt]
    add_index :users, :token
    add_index :users, :number
    add_index :users, :email
    add_index :users, :remember_token
  end

  def self.down
    drop_table(:users)
  end
end

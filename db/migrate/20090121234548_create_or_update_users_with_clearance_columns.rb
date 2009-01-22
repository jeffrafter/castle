class CreateOrUpdateUsersWithClearanceColumns < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.string :encrypted_password, :limit => 40
      t.boolean :email_confirmed, :default => false, :null => false
    end
    
    add_index :users, [:email, :encrypted_password]
  end
  
  def self.down
    change_table(:users) do |t|
      t.remove :encrypted_password,:email_confirmed
    end
  end
end

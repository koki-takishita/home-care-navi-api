class RemoveActivationDigestToUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :activation_digest, :string
  end
end

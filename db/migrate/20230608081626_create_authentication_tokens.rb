class CreateAuthenticationTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :authentication_tokens do |t|
      t.uuid :user_id, index: true
      t.string :hashed_id

      t.timestamps
    end
    add_index :authentication_tokens, :hashed_id, unique: true
  end
end

class CreateSecretMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :secret_messages do |t|
      t.string :message

      t.timestamps
    end
  end
end

class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login
      t.integer :git_id
      t.string :avatar_url
      t.string :url
      t.string :html_url
      t.string :name
      t.string :company
      t.string :blog
      t.string :location
      t.string :email
      t.string :bio
      t.boolean :hireable
      t.integer :public_repos
      t.integer :public_gists
      t.integer :followers
      t.integer :following

      t.timestamps
    end
  end
end

defmodule Blog.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :author, :text, null: false
      add :content, :text, null: false
      add :post_id, references(:posts, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:comments, [:post_id])
  end
end

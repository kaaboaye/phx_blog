defmodule Blog.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.Posts.Post

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :author, :string
    field :content, :string
    belongs_to :post, Post

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:author, :content, :post_id])
    |> validate_required([:author, :content, :post_id])
  end
end

defmodule BlogWeb.CommentControllerTest do
  use BlogWeb.ConnCase

  alias Blog.Comments
  alias Blog.Posts

  @post %{content: "some content", title: "some title"}
  @create_attrs %{author: "some author", content: "some content"}
  @update_attrs %{author: "some updated author", content: "some updated content"}
  @invalid_attrs %{author: nil, content: nil}

  def fixture(:post) do
    {:ok, post} = Posts.create_post(@post)

    post
  end

  def fixture(:comment) do
    post = fixture(:post)

    {:ok, comment} =
      @create_attrs
      |> Map.put(:post_id, post.id)
      |> Comments.create_comment()

    {post, comment}
  end

  describe "index" do
    setup [:create_post]

    test "lists all comments", %{conn: conn, post: post} do
      conn = get(conn, Routes.post_comment_path(conn, :index, post.id))
      assert html_response(conn, 200) =~ "Listing Comments"
    end
  end

  describe "new comment" do
    setup [:create_post]

    test "renders form", %{conn: conn, post: post} do
      conn = get(conn, Routes.post_comment_path(conn, :new, post.id))
      assert html_response(conn, 200) =~ "New Comment"
    end
  end

  describe "create comment" do
    setup [:create_post]

    test "redirects to show when data is valid", %{conn: conn, post: post} do
      attrs = Map.put(@create_attrs, :post_id, post.id)
      conn = post(conn, Routes.post_comment_path(conn, :create, post.id), comment: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.post_comment_path(conn, :show, post.id, id)

      conn = get(conn, Routes.post_comment_path(conn, :show, post.id, id))
      assert html_response(conn, 200) =~ "Show Comment"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = post(conn, Routes.post_comment_path(conn, :create, post.id), comment: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Comment"
    end
  end

  describe "edit comment" do
    setup [:create_comment]

    test "renders form for editing chosen comment", %{conn: conn, comment: comment} do
      conn = get(conn, Routes.post_comment_path(conn, :edit, comment.post_id, comment))
      assert html_response(conn, 200) =~ "Edit Comment"
    end
  end

  describe "update comment" do
    setup [:create_comment]

    test "redirects when data is valid", %{conn: conn, comment: comment} do
      conn =
        put(conn, Routes.post_comment_path(conn, :update, comment.post_id, comment),
          comment: @update_attrs
        )

      assert redirected_to(conn) ==
               Routes.post_comment_path(conn, :show, comment.post_id, comment)

      conn = get(conn, Routes.post_comment_path(conn, :show, comment.post_id, comment))
      assert html_response(conn, 200) =~ "some updated author"
    end

    test "renders errors when data is invalid", %{conn: conn, comment: comment} do
      conn =
        put(conn, Routes.post_comment_path(conn, :update, comment.post_id, comment),
          comment: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Comment"
    end
  end

  describe "delete comment" do
    setup [:create_comment]

    test "deletes chosen comment", %{conn: conn, comment: comment} do
      conn = delete(conn, Routes.post_comment_path(conn, :delete, comment.post_id, comment))
      assert redirected_to(conn) == Routes.post_comment_path(conn, :index, comment.post_id)

      assert_error_sent 404, fn ->
        get(conn, Routes.post_comment_path(conn, :show, comment.post_id, comment))
      end
    end
  end

  defp create_post(_) do
    {:ok, post: fixture(:post)}
  end

  defp create_comment(_) do
    {post, comment} = fixture(:comment)
    {:ok, post: post, comment: comment}
  end
end

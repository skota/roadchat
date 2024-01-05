defmodule RoadchatWeb.API.V1.S3Controller do
  use RoadchatWeb, :controller


  def get_profile_presigned_url(conn, %{"filename" => filename}) do
    config = %{region: "us-east-1"}
    {:ok, presigned_url} = ExAws.Config.new(:s3, config)
        |> ExAws.S3.presigned_url(:put, "roadchat/profile", "#{filename}.jpg", acl: :public_read)

    conn
    |> put_status(200)
    |> json(%{ url: presigned_url})

  end


  def get_post_presigned_url(conn, %{"filename" => filename}) do
    config = %{region: "us-east-1"}
    {:ok, presigned_url} = ExAws.Config.new(:s3, config)
    |> ExAws.S3.presigned_url(:put, "roadchat/post", "#{filename}.jpg", acl: :public_read)

    conn
    |> put_status(200)
    |> json(%{ url: presigned_url})

  end

  def get_item_presigned_url(conn, %{"filename" => filename}) do
    config = %{region: "us-east-1"}
    {:ok, presigned_url} = ExAws.Config.new(:s3, config)
    |> ExAws.S3.presigned_url(:put, "roadchat/item", "#{filename}.jpg", acl: :public_read)

    conn
    |> put_status(200)
    |> json(%{ url: presigned_url})

  end


end

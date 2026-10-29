defmodule EphnRevel.Search do
  @moduledoc """Meilisearch (MIT) adapter. Open-source, free for commercial use.
  Typo-tolerant, faceted filtering for nodes (tasks, emails, etc.).
  """

  @index "nodes"

  def configured? do
    not is_nil(endpoint()) and endpoint() != ""
  end

  def endpoint, do: Application.get_env(:ephnrevel, :meilisearch_endpoint, "http://127.0.0.1:7700")
  def api_key, do: Application.get_env(:ephnrevel, :meilisearch_api_key)

  def ensure_index do
    if configured?() do
      _ = Req.post("#{endpoint()}/indexes", json: %{uid: @index, primaryKey: "id"}, headers: headers())
      :ok
    end
  end

  def index_node(node) do
    if configured?() do
      doc = %{
        id: node.id,
        type: node.type,
        title: node.title,
        column: get_in(node.payload || %{}, ["column"]) || "backlog",
        subject: get_in(node.payload || %{}, ["subject"]),
        from: get_in(node.payload || %{}, ["from"]),
        text: Enum.join([node.title, node.type, inspect(node.payload)], " ")
      }

      Req.post("#{endpoint()}/indexes/#{@index}/documents", json: [doc], headers: headers())
    end
    :ok
  end

  def search(query, filters \\ []) do
    if configured?() do
      filter_str = Enum.join(filters, " AND ")
      body = %{q: query || "", filter: if(filter_str == "", do: nil, else: filter_str)}

      case Req.post("#{endpoint()}/indexes/#{@index}/search", json: body, headers: headers()) do
        {:ok, %{status: 200, body: body}} ->
          body["hits"] || []

        _ ->
          []
      end
    else
      []
    end
  end

  defp headers do
    base = [{"Content-Type", "application/json"}]
    if key = api_key(), do: [{"Authorization", "Bearer #{key}"} | base], else: base
  end
end

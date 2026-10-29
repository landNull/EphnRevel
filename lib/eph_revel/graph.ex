defmodule EphRevel.Graph do
  @moduledoc """Graph plane: nodes and links. CLI and web both call this."""

  import Ecto.Query, warn: false
  alias EphRevel.Repo
  alias EphRevel.Graph.{Node, Link}
  alias EphRevel.Search

  def list_nodes(type \\ nil) do
    query = from n in Node, order_by: [asc: n.title]
    query = if type, do: from(n in query, where: n.type == ^type), else: query
    Repo.all(query)
  end

  def get_node!(id), do: Repo.get!(Node, id)
  def get_node(id), do: Repo.get(Node, id)

  def create_node(attrs) do
    result =
      %Node{}
      |> Node.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, node} ->
        Search.index_node(node)
        {:ok, node}

      other ->
        other
    end
  end

  def update_node(%Node{} = node, attrs) do
    result =
      node
      |> Node.changeset(attrs)
      |> Repo.update()

    case result do
      {:ok, updated} ->
        Search.index_node(updated)
        {:ok, updated}

      other ->
        other
    end
  end

  def delete_node(%Node{} = node), do: Repo.delete(node)

  def create_link(attrs) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  def board(type \\ nil, query \\ nil, filters \\ []) do
    if Search.configured?() and (query || filters != []) do
      # Prefer Meilisearch for filtered/search views
      hits = Search.search(query || "", filters)
      ids = Enum.map(hits, & &1["id"])
      nodes = from(n in Node, where: n.id in ^ids) |> Repo.all()
      Enum.group_by(nodes, fn n -> get_in(n.payload, ["column"]) || "backlog" end)
    else
      nodes = list_nodes(type)
      Enum.group_by(nodes, fn n -> get_in(n.payload, ["column"]) || "backlog" end)
    end
  end

  def dashboard do
    nodes = Repo.aggregate(Node, :count)
    links = Repo.aggregate(Link, :count)
    emails = Repo.aggregate(from(n in Node, where: n.type == "email"), :count)
    %{nodes: nodes, links: links, emails: emails}
  end
end

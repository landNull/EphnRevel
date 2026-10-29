defmodule EphRevel.Graph do
  @moduledoc """Graph plane: nodes and links. CLI and web both call this."""

  import Ecto.Query, warn: false
  alias EphRevel.Repo
  alias EphRevel.Graph.{Node, Link}

  def list_nodes(type \\ nil) do
    query = from n in Node, order_by: [asc: n.title]
    query = if type, do: from(n in query, where: n.type == ^type), else: query
    Repo.all(query)
  end

  def get_node!(id), do: Repo.get!(Node, id)
  def get_node(id), do: Repo.get(Node, id)

  def create_node(attrs) do
    %Node{}
    |> Node.changeset(attrs)
    |> Repo.insert()
  end

  def update_node(%Node{} = node, attrs) do
    node
    |> Node.changeset(attrs)
    |> Repo.update()
  end

  def delete_node(%Node{} = node), do: Repo.delete(node)

  def create_link(attrs) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  def board(type \\ nil) do
    nodes = list_nodes(type)
    Enum.group_by(nodes, fn n -> get_in(n.payload, ["column"]) || "backlog" end)
  end

  def dashboard do
    nodes = Repo.aggregate(Node, :count)
    links = Repo.aggregate(Link, :count)
    %{nodes: nodes, links: links}
  end
end

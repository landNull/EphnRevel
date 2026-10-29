defmodule EphnRevel.Graph.Node do
  use Ecto.Schema
  import Ecto.Changeset

  schema "nodes" do
    field :type, :string
    field :title, :string
    field :payload, :map, default: %{}
    field :external_id, :string

    has_many :outgoing_links, EphnRevel.Graph.Link, foreign_key: :source_id
    has_many :incoming_links, EphnRevel.Graph.Link, foreign_key: :target_id

    timestamps(type: :utc_datetime)
  end

  def changeset(node, attrs) do
    node
    |> cast(attrs, [:type, :title, :payload, :external_id])
    |> validate_required([:type, :title])
    |> validate_length(:title, min: 1)
  end
end

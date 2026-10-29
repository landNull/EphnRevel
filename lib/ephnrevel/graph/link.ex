defmodule EphnRevel.Graph.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :kind, :string
    field :payload, :map, default: %{}

    belongs_to :source, EphnRevel.Graph.Node
    belongs_to :target, EphnRevel.Graph.Node

    timestamps(type: :utc_datetime)
  end

  def changeset(link, attrs) do
    link
    |> cast(attrs, [:kind, :payload, :source_id, :target_id])
    |> validate_required([:kind, :source_id, :target_id])
    |> foreign_key_constraint(:source_id)
    |> foreign_key_constraint(:target_id)
  end
end

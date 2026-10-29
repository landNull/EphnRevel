defmodule EphRevel.Repo.Migrations.CreateNodesAndLinks do
  use Ecto.Migration

  def change do
    create table(:nodes) do
      add :type, :string, null: false
      add :title, :string, null: false
      add :payload, :map, default: %{}
      add :external_id, :string

      timestamps(type: :utc_datetime)
    end

    create index(:nodes, [:type])
    create unique_index(:nodes, [:external_id])

    create table(:links) do
      add :kind, :string, null: false
      add :payload, :map, default: %{}
      add :source_id, references(:nodes, on_delete: :delete_all), null: false
      add :target_id, references(:nodes, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:links, [:source_id])
    create index(:links, [:target_id])
  end
end

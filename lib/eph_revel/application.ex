defmodule EphRevel.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EphRevelWeb.Telemetry,
      EphRevel.Repo,
      {DNSCluster, query: Application.get_env(:eph_revel, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EphRevel.PubSub},
      {Finch, name: EphRevel.Finch},
      EphRevelWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: EphRevel.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    EphRevelWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

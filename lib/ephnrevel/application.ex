defmodule EphnRevel.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EphnRevelWeb.Telemetry,
      EphnRevel.Repo,
      {DNSCluster, query: Application.get_env(:ephnrevel, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EphnRevel.PubSub},
      {Finch, name: EphnRevel.Finch},
      EphnRevelWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: EphnRevel.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    EphnRevelWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

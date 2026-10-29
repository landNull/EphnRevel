defmodule EphRevel.CLI do
  @moduledoc """revelctl Mix task entry. CLI-first control plane."""

  alias EphRevel.Graph

  def main(args) do
    {opts, rest, _} =
      OptionParser.parse(args,
        strict: [set: :keep, type: :string],
        aliases: [s: :set]
      )

    case rest do
      ["create", type, title] ->
        payload = payload_from_opts(opts)
        {:ok, node} = Graph.create_node(%{type: type, title: title, payload: payload})
        IO.puts("#{node.id}  #{node.type}  #{node.title}")

      ["list"] ->
        for node <- Graph.list_nodes() do
          IO.puts("#{node.id}  #{node.type}  #{node.title}")
        end

      ["board"] ->
        columns = Graph.board()
        for {col, nodes} <- columns do
          IO.puts("[#{col}]")
          for n <- nodes, do: IO.puts("  #{n.id}  #{n.title}")
        end

      ["query", id] ->
        node = Graph.get_node!(id)
        IO.puts("#{node.id}  #{node.type}  #{node.title}  #{inspect(node.payload)}")

      _ ->
        IO.puts("""
        revelctl — control plane
          mix revelctl create TYPE TITLE [--set key=value]
          mix revelctl list
          mix revelctl board
          mix revelctl query ID
        """)
    end
  end

  defp payload_from_opts(opts) do
    opts
    |> Keyword.get_values(:set)
    |> Enum.reduce(%{}, fn pair, acc ->
      case String.split(pair, "=", parts: 2) do
        [k, v] -> Map.put(acc, k, v)
        _ -> acc
      end
    end)
  end
end

defmodule EphRevel.CLI do
  @moduledoc """revelctl Mix task entry. CLI-first control plane."""

  alias EphRevel.Graph
  alias EphRevel.Mail

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
          for n <- nodes, do: IO.puts("  #{n.id}  #{n.type}  #{n.title}")
        end

      ["query", id] ->
        node = Graph.get_node!(id)
        IO.puts("#{node.id}  #{node.type}  #{node.title}  #{inspect(node.payload)}")

      ["mail", "status"] ->
        s = Mail.status()
        IO.puts("imap=#{s.imap_host}:#{s.imap_port}  smtp=#{s.smtp_host}:#{s.smtp_port}  user=#{s.user || "(unset)"}  configured=#{s.configured}")

      ["mail", "fetch"] ->
        {:ok, _} = Mail.fetch_inbox()
        IO.puts("fetch complete (demo node created; wire real IMAP for production)")

      ["mail", "send", to, subject, body] ->
        {:ok, node} = Mail.send_mail(to, subject, body)
        IO.puts("#{node.id}  email  #{node.title}")

      _ ->
        IO.puts("""
        revelctl — control plane
          mix revelctl create TYPE TITLE [--set key=value]
          mix revelctl list
          mix revelctl board
          mix revelctl query ID
          mix revelctl mail status|fetch|send TO SUBJECT BODY
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

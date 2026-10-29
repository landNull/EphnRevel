defmodule Mix.Tasks.Revelctl do
  use Mix.Task

  @shortdoc "revelctl control plane"
  @impl true
  def run(args) do
    Mix.Task.run("app.start")
    EphnRevel.CLI.main(args)
  end
end

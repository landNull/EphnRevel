defmodule EphRevel.Mail do
  @moduledoc """Email adapter (EspoCRM-style personal account).
  Emails become task nodes (type: email) so they appear on the kanban.
  Zoho defaults: imap.zoho.com:993 SSL, smtp.zoho.com:465 SSL / 587 TLS.
  Credentials via env (never stored in repo).
  """

  alias EphRevel.Graph
  alias EphRevel.Search

  def status do
    %{
      imap_host: System.get_env("EPH_IMAP_HOST", "imap.zoho.com"),
      imap_port: System.get_env("EPH_IMAP_PORT", "993"),
      smtp_host: System.get_env("EPH_SMTP_HOST", "smtp.zoho.com"),
      smtp_port: System.get_env("EPH_SMTP_PORT", "465"),
      user: System.get_env("EPH_MAIL_USER"),
      configured: not is_nil(System.get_env("EPH_MAIL_USER")) and not is_nil(System.get_env("EPH_MAIL_PASSWORD"))
    }
  end

  @doc """Create an email node (appears on kanban under payload.column, default 'inbox')."""
  def create_email_node(attrs) do
    payload =
      Map.merge(
        %{
          "column" => "inbox",
          "from" => attrs["from"],
          "to" => attrs["to"],
          "subject" => attrs["subject"],
          "body" => attrs["body"],
          "message_id" => attrs["message_id"]
        },
        attrs["payload"] || %{}
      )

    title = attrs["subject"] || attrs["title"] || "(no subject)"

    {:ok, node} =
      Graph.create_node(%{
        type: "email",
        title: title,
        payload: payload
      })

    Search.index_node(node)
    {:ok, node}
  end

  @doc """Stub for IMAP fetch. Real implementation uses an IMAP client (e.g. Yugo or custom :ssl).
  Creates email nodes from fetched messages so they appear on the board.
  """
  def fetch_inbox(limit \\ 20) do
    # Placeholder: in production wire to IMAP (imap.zoho.com:993).
    # Example flow:
    # 1. Connect SSL to System.get_env("EPH_IMAP_HOST", "imap.zoho.com"):993
    # 2. LOGIN with EPH_MAIL_USER / EPH_MAIL_PASSWORD (app password for Zoho 2FA)
    # 3. SELECT INBOX, SEARCH UNSEEN, FETCH body/envelope
    # 4. For each message call create_email_node/1
    # For now return a demo email node so the board can show the pattern.
    create_email_node(%{
      "from" => "demo@example.com",
      "to" => System.get_env("EPH_MAIL_USER") || "you@zoho.com",
      "subject" => "Demo email (IMAP stub)",
      "body" => "Wire a real IMAP client here. Zoho: imap.zoho.com:993 SSL.",
      "message_id" => "demo-#{System.unique_integer()}"
    })

    {:ok, limit}
  end

  @doc """SMTP send stub. Use Swoosh.Adapters.SMTP in production.
  After send, record as email node.
  """
  def send_mail(to, subject, body) do
    # Production: Swoosh with smtp.zoho.com:465 ssl: true or 587 tls: :always
    create_email_node(%{
      "from" => System.get_env("EPH_MAIL_USER") || "you@zoho.com",
      "to" => to,
      "subject" => subject,
      "body" => body,
      "column" => "sent"
    })
  end
end

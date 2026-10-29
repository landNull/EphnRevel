# Fetch email as nodes

This is a how-to. It assumes environment variables for Zoho are set.

1. Export the credentials:

   ```sh
   export EPH_MAIL_USER=you@zoho.com
   export EPH_MAIL_PASSWORD=app-password
   export EPH_IMAP_HOST=imap.zoho.com
   export EPH_SMTP_HOST=smtp.zoho.com
   ```

2. From the project root:

   ```sh
   mix revelctl mail status
   mix revelctl mail fetch
   ```

3. Each fetched message becomes a node with `type: "email"`. It appears on the Board under the column named in its payload (default `inbox`).

See [Why emails are nodes](../explanation/why-emails-are-nodes.md).

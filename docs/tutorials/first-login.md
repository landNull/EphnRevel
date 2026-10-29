# First login

This is a tutorial. It takes a reader from a bare clone to a working session.

## Prerequisites

- Elixir 1.16+
- Mix
- SQLite

## Steps

1. Clone the repository.

   ```sh
   git clone https://github.com/landNull/Eph-Revel.git
   cd Eph-Revel
   git checkout rename-to-ephnrevel
   ```

2. Install dependencies and create the database.

   ```sh
   mix deps.get
   mix ecto.setup
   ```

3. Start the server.

   ```sh
   mix phx.server
   ```

4. Open http://localhost:4000.

5. Log in with the seeded account:

   - email: `admin@example.com`
   - password: `password123456`

6. You land on the Dashboard. It shows node, email, and link counts.

7. Open the Board. Demo nodes appear in columns.

Next: [Create a node](../how-to/create-a-node.md).

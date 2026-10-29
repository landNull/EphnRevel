# Create a node

This is a how-to. It assumes the reader already has a running session.

1. From the Dashboard or Board, open **Nodes**.

2. Click **New Node**.

3. Fill the form:

   - Type: `task` (or `email`, `project`, or any string).
   - Title: the visible name.
   - External ID: optional.
   - Payload: a JSON object. Example:

     ```json
     {"column": "todo"}
     ```

4. Click **Save Node**.

The node appears in the Nodes list and, if it has a `column` key, on the Board.

See the [Graph reference](../reference/graph.md).

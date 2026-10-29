# Why emails are nodes

This is an explanation. It says why email messages become task nodes.

EspoCRM treats email as first-class work. Revel treats every element as a task node. EphnRevel combines both: an incoming message is stored as a node with `type: "email"`. It appears on the same Board as other tasks. Filtering and search treat it like any other node.

Credentials stay in the environment. They are never written to the repository. The IMAP fetch is currently a stub that creates a demo node; the contract is the same as a real fetch.

See [Fetch email as nodes](../how-to/fetch-email-as-nodes.md).

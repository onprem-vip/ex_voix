defmodule TodoAppMCP.Server do
  use Anubis.Server,
    name: "TodoApp MCP Server",
    version: TodoAppMCP.version(),
    capabilities: [:tools]

  component(TodoAppMCP.Components.AddTask)
  component(TodoAppMCP.Components.CompleteTask)
  component(TodoAppMCP.Components.RemoveTask)
  component(TodoAppMCP.Components.ShowUpdateTaskForm)
  component(TodoAppMCP.Components.ShowStatsWindow)
  component(TodoAppMCP.Components.CloseAnyForm)
  component(TodoAppMCP.Components.SaveTaskForm)
  component(TodoAppMCP.Components.UpdateFieldValue)

end

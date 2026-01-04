defmodule TodoAppMCP.Components.CloseUpdateTaskForm do
  @moduledoc """
  Show update task form
  """

  use Anubis.Server.Component,
    type: :tool

  alias Anubis.Server.Response
  alias ExVoix.ModelContext.UIResource
  alias ExVoix.ModelContext.UIResource.EncodingType
  alias ExVoix.ModelContext.UI.RemoteDomPayload

  schema do
    #field :id, :integer, required: true
  end

  @impl true
  def title() do
    "close_update_task_form"
  end

  @impl true
  def description() do
    "Close update task form"
  end

  @impl true
  def execute(_params, frame) do
    interactive_js = """
    JS.patch("/tasks")
    """
    lvjs_payload = RemoteDomPayload.new(%{
      framework: "liveviewjs",
      script: interactive_js
    })

    resource = UIResource.new(
      %{
        uri: "ui://todo_app/task-form",
        content: lvjs_payload,
        encoding: EncodingType.Text,
        # ui_metadata: %{},
        # metadata: %{}
      }
    )
    response = UIResource.create_response_from(Response.tool(), resource)

    {:reply, response, frame}
  end
end

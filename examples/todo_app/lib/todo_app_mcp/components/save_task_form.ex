defmodule TodoAppMCP.Components.SaveTaskForm do
  @moduledoc """
  Save task form
  """

  use Anubis.Server.Component,
    type: :tool

  alias Anubis.Server.Response
  alias ExVoix.ModelContext.UIResource
  alias ExVoix.ModelContext.UIResource.EncodingType
  alias ExVoix.ModelContext.UI.CommandPayload

  schema do
    # field :id, :integer, required: true
  end

  @impl true
  def title() do
    "save_task_form"
  end

  @impl true
  def description() do
    "Save task form"
  end

  @impl true
  def execute(_params, frame) do
    interactive_js = """
    JS.dispatch("click", to: "#save-task")
    """

    lvjs_payload = CommandPayload.new(%{
      framework: "liveviewjs",
      script: interactive_js |> String.trim()
    })

    resource = UIResource.new(
      %{
        uri: "ui://todo_app/save-task-form",
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

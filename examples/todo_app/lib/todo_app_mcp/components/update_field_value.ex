defmodule TodoAppMCP.Components.UpdateFieldValue do
  @moduledoc """
  Update field value in task form
  """

  use Anubis.Server.Component,
    type: :tool

  alias Anubis.Server.Response
  alias ExVoix.ModelContext.UIResource
  alias ExVoix.ModelContext.UIResource.EncodingType
  alias ExVoix.ModelContext.UI.CommandPayload

  schema do
    field :id, :string, required: true
    field :value, :string, required: true
  end

  @impl true
  def title() do
    "update_field_<%= item_id %>_value"
  end

  @impl true
  def description() do
    "Update field <%= item_label %> value"
  end

  @impl true
  def execute(%{id: id, value: new_value} = _params, frame) do
    interactive_js =
    case id do
      "task_priority" ->
        """
          JS.dispatch("set_value", detail: %{value: "#{String.downcase(new_value)}"}, to: "##{id}") |> JS.show(transition: {"ease-out duration-300", "opacity-0", "opacity-100"}, time: 300, to: "##{id}")
        """

      _ ->
        """
          JS.set_attribute({"value", "#{new_value}"}, to: "##{id}") |> JS.dispatch("input", to: "##{id}") |> JS.show(transition: {"ease-out duration-300", "opacity-0", "opacity-100"}, time: 300, to: "##{id}")
        """

    end

    lvjs_payload = CommandPayload.new(%{
      framework: "liveviewjs",
      script: interactive_js |> String.trim()
    })

    resource = UIResource.new(
      %{
        uri: "ui://todo_app/update-field-value",
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

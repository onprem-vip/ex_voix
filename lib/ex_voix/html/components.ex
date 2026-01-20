defmodule ExVoix.Html.Components do
  @moduledoc """
  Provides VOIX framework components for tool and context element.
  """
  use Phoenix.Component

  import Phoenix.HTML
  alias ExVoix.ModelContext.Registry
  alias ExVoix.Utils.LvJs

  @doc """
  Renders a tool element.

  ## Examples

      <.tool mcp={@mcp} name={@name} />
  """
  attr :mcp, :atom, required: true, doc: "the module of mcp server"
  attr :name, :any, required: true, doc: "the name of tool"
  attr :item_id, :any, doc: "the id related to item tool"
  attr :item_label, :string, doc: "the label related to item tool"

  def tool(assigns) do
    mcp = Registry.load_mcps() |> Enum.filter(fn it -> it == assigns[:mcp] end) |> Enum.at(0)
    assigns =
      if not is_nil(mcp) do
        tool = Registry.load_tool(mcp, assigns[:name]) |> Enum.at(0)
        # IO.inspect(tool, label: "tool element")
        assigns =
          assigns
          |> assign_new(:tool_name, fn _ ->
            if not is_nil(assigns[:item_id]) and not is_nil(Map.get(tool, "title")),
              do: EEx.eval_string(Map.get(tool, "title"), [item_id: assigns[:item_id]]), else: Map.get(tool, "name")
          end)
          |> assign_new(:tool_desc, fn _ ->
            if not is_nil(assigns[:item_label]),
              do: EEx.eval_string(Map.get(tool, "description"), [item_label: assigns[:item_label]]),
              else: Map.get(tool, "description")
          end)
        props = Map.get(tool, "inputSchema") |> Map.get("properties")
        properties =
          Enum.map(props, fn {prop_name, prop_info} ->
            "<prop name='#{prop_name}' type='#{Map.get(prop_info, "type", "")}' description='#{Map.get(prop_info, "description", "")}'></prop>"
          end)
        assigns
          |> assign_new(:props, fn _ ->
            properties
          end)
      else
        assigns
      end

    ~H"""
      <tool name={@tool_name} description={@tool_desc} class="hidden">
        <%= for prop <- @props do %>
          {raw(prop)}
        <% end %>
      </tool>
    """
  end

  @doc """
  Renders a context element.

  ## Examples

      <.context name={@name} content={@content} />
  """
  attr :name, :string, required: true, doc: "the name of context"
  attr :content, :string, required: true, doc: "the content of context"

  def context(assigns) do

    ~H"""
      <context id={"context_" <> @name} name={@name} class="hidden">
        {raw(@content)}
      </context>
    """
  end

  @doc """
  Renders a UI resource from mcp-ui.

  ## Examples

      <.ui_resource_renderer id="my-script" resource={@resource} />
  """
  attr :id, :string, required: true,
    doc: "the id of the element"

  attr :resource, :string, required: true,
    doc: "mcp-ui resource"

  def ui_resource_renderer(assigns) do

    assigns = if Map.has_key?(assigns, :resource) and not is_nil(assigns.resource), do: assigns, else: Map.put(assigns, :resource, %{})
    ~H"""
    <div id={@id} class="mt-4 space-y-5 bg-white hidden" value-js-code={ eval_lvjs_code(@resource) } phx-hook="VoixEventHandler">
    </div>
    """
  end

  defp eval_lvjs_code(resource) do
    if Map.get(resource, "mimeType", "") == "application/vnd.ex-voix.command+javascript; framework=liveviewjs" do
      LvJs.eval(Map.get(resource, "text", ""))
    else
      ""
    end
  end
end

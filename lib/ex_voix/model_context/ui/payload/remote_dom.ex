defmodule ExVoix.ModelContext.UI.RemoteDomPayload do

  @type t :: %__MODULE__{
    type: String.t(),
    framework: String.t() | nil,
    script: String.t() | nil
  }
  defstruct type: "remoteDom",
            framework: nil,
            script: nil

  def new(%{framework: "react", script: _script} = attrs) do
    struct!(__MODULE__, attrs)
  end

  def new(%{framework: "webcomponents", script: _script} = attrs) do
    struct!(__MODULE__, attrs)
  end

end

defmodule ExVoix.ModelContext.UI.DomPatchingPayload do

  @type t :: %__MODULE__{
    type: String.t(),
    framework: String.t() | nil,
    script: String.t() | nil
  }
  defstruct type: "domPatching",
            framework: nil,
            script: nil

  def new(%{framework: "liveviewjs", script: _script} = attrs) do
    struct!(__MODULE__, attrs)
  end

end

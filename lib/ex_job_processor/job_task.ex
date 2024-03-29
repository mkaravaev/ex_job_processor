defmodule ExJobProcessor.JobTask do
 @enforce_keys [:name, :command]

  defstruct [
    name: nil,
    command: nil,
    requires: nil
  ]

  @type t :: %__MODULE__{
    name: String.t,
    command: String.t,
    requires: [String.t] | nil
  }

end

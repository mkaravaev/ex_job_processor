defmodule ExJobProcessor.ProcessedJobTask do
 @enforce_keys [:name, :command]

  defstruct [
    name: nil,
    command: nil,
  ]

  @type t :: %__MODULE__{
    name: String.t,
    command: String.t
  }

end

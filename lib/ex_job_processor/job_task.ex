defmodule ExJobProcessor.JobTask do
 @enforce_keys [:name, :command]

  defstruct [
    name: nil,
    command: nil,
    executed: false
  ]

  @type t :: %__MODULE__{
    name: String.t,
    command: String.t,
    executed: boolean
  }


end

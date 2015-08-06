
defmodule Issues.CLI do
  @default_count 10
  @moduledoc """
    Dispatch to the several functions that generate
    a the result(a table of the last _n_  issues in
    a github repo) or help for the program.
  """
  def run(argv) do
    argv
      |> parse_args
      |> process
      #sort_result |>
      #display_table
  end

  @doc """
  `argv` can be -h or --help. which returns :help.

  Otherwise it is a githun user name, project name,
  and optionally the number of tentries format.
   Return a tuple of `{user, project, count}`, or `:help` if -h or
   --help were received.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, swintches: [help: :boolean],
                                     aliases:   [h:    :help   ])
    case parse do
      { [help: true], _, _ }
        -> :help

      { _, [user, project, count], _ }
        -> { user, project, String.to_integer(count) }

      {_, [user, project], _}
        -> { user, project, @default_count }

      _ -> :help
    end
  end

  @doc """
    Shows help when requested
  """
  def process(:help) do
    IO. puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

end

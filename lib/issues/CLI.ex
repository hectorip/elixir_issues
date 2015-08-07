
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
  
  @doc """
    Process username, repo and number of requested issues
  """
  def process({user, project, _count}) do
    Issues.GithubRetriever.get(user, project)
      |> decode_response
      |> convert_to_list_of_hashdicts
      |> sort_into_ascending_order
      |> Enum.take _count
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, body}) do
    {_, message} = List.keyfind(body, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end
  def convert_to_list_of_hashdicts(list) do
    list
      |> Enum.map(&Enum.into(&1, HashDict.new))
  end
  def sort_into_ascending_order(list) do
    Enum.sort list,
              fn item_1, item_2 -> item_1["created_at"] <= item_2["created_at"] end
  end
end


defmodule CliTest do
  use ExUnit.Case
  import Issues.CLI, only: [
    parse_args: 1,
    sort_into_ascending_order: 1,
    convert_to_list_of_hashdicts: 1,
    max_by_column: 2,
    pluck: 2
  ]
  test ":help is returned by option parsing with -h option" do
    assert parse_args(["-h", "anything"]) == :help
  end
  test ":help is returned by option parsing with --help option" do
    assert parse_args(["--help", "..."]) == :help
  end
  test "the configunt param returned is default if no present" do
    assert parse_args(["user", "project"]) == {"user", "project", 10}
  end
  test "it returns the values as a tuple" do
    assert parse_args(["a_user", "the_project", "10"]) == {"a_user", "the_project", 10}
  end
  test "sort ascending orders in the right way" do
    data = sort_into_ascending_order(fake_issues_list(["c", "d", "a", "e", "b"]))
    created_at = for i <- data, do: i["created_at"]
    assert created_at == ~w{a b c d e}
  end
  defp fake_issues_list(list) do
    data = for value <- list,
           do: [{"created_at", value}, {"more_data", "..."}]
    convert_to_list_of_hashdicts(data)
  end
  test "Max is returning max" do
    list = fake_issues_list(["caaa", "dss", "123456", "1", "4"])
    assert max_by_column(list, "created_at") == 6
  end
  test "Pluck extracts max values from a column in a collection" do
     list = fake_issues_list(["caaa", "dss", "123456", "1", "4"])
     assert pluck(list, "created_at") == [4, 3, 6, 1, 1]
  end
end

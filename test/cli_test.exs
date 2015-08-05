defmodule CliTest do
  use ExUnit.Case
  import Issues.CLI, only: [parse_args: 1]
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
end

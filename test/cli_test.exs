defmodule CliTest do
  use ExUnit.Case
  import Issues.CLI, only: [parse_args: 1]
  test ":help is returned by option parsing with -h option" do
    assert parse_args(["-h", "anything"]) == :help
  end
  test ":help is returned by option parsing with --help option" do
    assert parse_args(["--help", "..."]) == :help
  end
end

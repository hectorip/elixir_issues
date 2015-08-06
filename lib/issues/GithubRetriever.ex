defmodule GithubRetriever do
  @user_agent [{"User-agent", "Elixir hectorivanpatriciomoreno@gmail.com"}]
  def get(user, project) do
    url(user, project)
      |> HTTPoison.get(@user_agent)
      |> handle_response
  end
  def url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end
  def handle_response(%{status_code: 200, body: body}), do { :ok, body }
  def handle_response(%{status_code: ___, body: body}), do { :error, body }
end

defmodule Issues.GithubRetriever do
  @user_agent [{"User-agent", "Elixir hectorivanpatriciomoreno@gmail.com"}]
  @github_url Application.get_env(:issues, :github_url)
  def get(user, project) do
    url(user, project)
      |> HTTPoison.get(@user_agent)
      |> handle_response
  end
  def url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end
  def handle_response({ status , response}), do: { status, :jsx.decode(response.body) }
end

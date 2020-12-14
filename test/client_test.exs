defmodule Exgit.ClientTest do
  use ExUnit.Case

  import Tesla.Mock

  describe "get_repos_by_username/1" do
    test "when the user repos, returns the repos" do
      username = "marciocamello"

      response = [
        %{"id" => 1, "name" => "My repo 1" },
        %{"id" => 1, "name" => "My repo 1" }
      ]

      expected_response = {:ok, response}

      mock(fn %{method: :get, url: "https://api.github.com/users/marciocamello/repos"} ->
        %Tesla.Env{status: 200, body: response}
      end)

      assert Exgit.Client.get_repos_by_username(username) == expected_response

    end

    test "when the aws not found, returns an error" do
      username = "marciocamello"
      expected_response = {:error, "User not found"}

      mock(fn %{method: :get, url: "https://api.github.com/users/marciocamello/repos"} ->
        %Tesla.Env{status: 404, body: ""}
      end)

      assert Exgit.Client.get_repos_by_username(username) == expected_response

    end
  end
end

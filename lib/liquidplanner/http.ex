defmodule LiquidPlanner.HTTP do

  require Logger
  use GenServer

  @base_uri Application.get_env(:liquidplanner, :uri)
  @token Application.get_env(:liquidplanner, :token)

  def get(url, opts \\ []) do
    Logger.info "Getting from: `#{@base_uri <> url}` token: `#{@token}`"
    HTTPoison.get(@base_uri <> url,
                  [{"Authorization", "Bearer " <> @token} | opts])
  end

  def post(url, opts \\ []) do
    Logger.info "Posting to: `#{@base_uri <> url}` token: `#{@token}`"
    HTTPoison.post(@base_uri <> url,
                   [{"Authorization", "Bearer " <> @token} | opts])
  end

  def put(url, opts \\ []) do
    Logger.info "Putting to: `#{@base_uri <> url}` token: `#{@token}`"
    HTTPoison.put(@base_uri <> url,
                  [{"Authorization", "Bearer " <> @token} | opts])
  end

  # Look into making these better with macros...
  def account do
    case get("/account") do
      {:ok, data} -> Poison.decode!(data.body)
      _ -> :error
    end
  end

  def workspaces do
    case get("/workspaces") do
      {:ok, data} -> Poison.decode!(data.body)
      _ -> :error
    end
  end

  def projects do
    case get "/workspaces/#{workspace_id()}/projects" do
      {:ok, data} -> Poison.decode!(data.body)
      _ -> :error
    end
  end

  def tasks do
    case get "/workspaces/#{workspace_id()}/tasks" do
      {:ok, data} -> Poison.decode!(data.body)
      _ -> :error
    end
  end

  def create_task(data) do
    opts = [{:body, {:task, data}}]
    { 'name' => 'learn the API', 'parent_id' => projects.first['id'] }
    post "workspaces/#{workspace_id()}/tasks", opts
  end

  ##############################################################################
  # Under-the-hood
  def workspace_id do
    GenServer.call(__MODULE__, :workspace_id)
  end

  ##############################################################################
  # GenServer Stuff...
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # change this
  def init(_args) do
    # wksp = workspaces()
    {:ok, %{}}
  end

  # and these...
  def handle_call(:workspace_id, _from, db) do
    case Map.get(db, :workspace_id) do
      nil ->
        wksp = workspaces() |> hd |> Map.get("id")
        Logger.debug "Woorkspace: #{inspect(wksp)}, DB: #{inspect(db)}"
        {:reply, wksp, Map.put(db, :workspace_id, wksp)}
      id ->
        {:reply, id, db}
    end
  end
  # def handle_call(:file, _from, db) do
  #   {:reply, db[:file], db}
  # end
  # def handle_call({:data, key}, _from, db) do
  #   {:reply, Map.fetch(db[:data], key), db}
  # end
  # def handle_call({:data, :events, value}, _from, db) do
  #   evs = get_in(db, [:data, :events])
  #   data = put_in(db, [:data, :events], [value | evs])
  #   case write_db(db[:file], data[:data]) do
  #     :ok -> {:reply, :ok, data}
  #     derp -> derp
  #   end
  # end
  # def handle_call({:data, keys, value}, _from, db) do
  #   data = put_in(db, [:data] ++ keys, value)
  #   case write_db(db[:file], data[:data]) do
  #     :ok -> {:reply, :ok, data}
  #     derp -> derp
  #   end
  # end

end

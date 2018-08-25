defmodule Pooly.Supervisor do
    # the main, top-level SV
    use Supervisor

    def start_link(pools_config) do
        Supervisor.start_link(__MODULE__, pools_config, name: __MODULE__)
    end # 'name:' - adds refering to name

    def init(pools_config) do
        children = [
            supervisor( Pooly.PoolsSupervisor, [] ),
            worker( Pooly.Server, [pools_config] )
            ]

        opts = [strategy: :one_for_all]

        supervise(children, opts) # consists Pooly.Server
    end
    # Pooly.Server.start_link takes 1. pid of this SV; 2. pool_config

end

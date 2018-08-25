defmodule Pooly.WorkerSupervisor do
    use Supervisor
    #######
    # API #
    #######
    def start_link(pool_server, {_, _, _} = mfa) do
        Supervisor.start_link(__MODULE__, [pool_server, mfa])
    end


    #############
    # Callbacks #
    #############
    def init([pool_server, {m, f, a}]) do # m - module / f - function / a - args
        Process.link(pool_server) # if one dies - second one too
        worker_opts = [restart: :temporary,
                        shutdown: 5000,
                        function: f]

        children = [worker(m, a, worker_opts)] # wr module/args/opts_to_manipulate

        opts = [strategy: :simple_one_for_one, # opts for SV
                max_restarts: 5, #5
                max_seconds: 5]
        supervise(children, opts) # watch children with such opts
    end

end

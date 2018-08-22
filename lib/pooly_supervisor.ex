defmodule Pooly.WorkerSupervisor do
    use Supervisor
    #######
    # API #
    #######
    def start_link({_, _, _} = mfa) do
        Supervisor.start_link(__MODULE__, mfa)
    end


    #############
    # Callbacks #
    #############
    def init({m, f, a} = _x) do # m - module / f - function / a - args
        worker_opts = [restart: :permanent,
                        function: f]

        children = [worker(m, a, worker_opts)] # wr module/args/opts_to_manipulate

        opts = [strategy: :simple_one_for_one, # opts for SV
                max_restarts: 5, #5
                max_seconds: 5]
        supervise(children, opts) # watch children with such opts
    end

end

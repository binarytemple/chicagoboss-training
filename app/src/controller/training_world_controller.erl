-module(training_world_controller, [Req]).
-compile(export_all).

%simple route
hello('GET', []) ->
    {ok,[ 
            {erl_date, erlang:date()},
            {erl_time, erlang:time()}
        ] }.

%aka 404
lost('GET',[]) ->
    {ok, [ { original_path, Req:path() } ]    }.

%aka 500
calamity('GET', []) ->
        {output, "calamity!"}.

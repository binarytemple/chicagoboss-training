-module(training_base_controller, [Req]).
-compile(export_all).

%simple route
hello('GET', []) ->
  {ok, [
    {erl_date, erlang:date()},
    {erl_time, erlang:time()}
  ]}.

%simple route
index('GET', []) ->
  {ok, [
    {erl_date, erlang:date()},
    {erl_time, erlang:time()}
  ]}.

%aka 404
lost('GET', []) ->
  lager:log(warning, self(), "invalid route requested : ~p ", [Req:path()]),
  {ok, [{original_path, Req:path()}]}.

%aka 500
calamity('GET', []) ->
  lager:log(error, self(), "crash requesting : ~p", [Req:path()]),
  {output, "calamity!"}.

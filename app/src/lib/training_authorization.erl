-module(training_authorization).
-author("bryanhunt").

%% API
-export([maybe_require_login/1]).

maybe_require_login(_Req) ->
  ok.
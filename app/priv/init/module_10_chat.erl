%% file: priv/init/module_10_bcrypt.erl
-module(module_10_chat). 
-export([init/0, stop/0]). 

%% We need to manually start the chat application.
%% @TODO: figure out how to get this to run via boss.config.
init() -> 
    %% Uncomment the following line if your CB app doesn't start crypto on its own
    % crypto:start(),
    chat_app:start(). 

stop() -> 
    ok. %%bcrypt:stop(). 
    %% Comment the above and uncomment the following lines 
    %% if your CB app doesn't start crypto on its own
    % bcrypt:stop(),
    % crypto:stop().

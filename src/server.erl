-module(server).

%% API exports
-export([main/1]).

loop(Socket) ->
    {ok, Recv} = erlzmq:recv(Socket),
    io:format("New msg: ~p\n", [Recv]),

    erlzmq:send(Socket, <<"Server test">>),
    loop(Socket).

main(_Args) ->
    {ok, Context} = erlzmq:context(),
    {ok, Socket} = erlzmq:socket(Context, rep),

    case erlzmq:bind(Socket, "ipc:///home/test") of
        ok ->
            io:format("server start\n"),
            loop(Socket);
        {error, Error} ->
            io:format("socket binding error: ~p\n", [Error]),
            erlang:halt(1)
    end,

    erlzmq:close(Socket),
    erlang:halt(0).

%%====================================================================
%% Internal functions
%%====================================================================

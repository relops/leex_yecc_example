-ifdef(debug).
-define(LOG0(Msg), 
        io:format("{~p:~p}: ~p~n", [?MODULE, ?LINE, Msg])).
-define(LOG(Name, Value), 
        io:format("{~p:~p}: ~p -> ~p~n", [?MODULE, ?LINE, Name, Value])).
-define(ERROR(Error,Reason), 
        io:format("Error @ ~p:~p: ~p (Reason: ~p)~n", [?MODULE, ?LINE,Error,Reason])).
-else.
-define(LOG0(A), true).
-define(LOG(A,B), true).
-define(ERROR(A), true).
-endif.

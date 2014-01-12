-module(selector).

-include("selector.hrl").

-define(LEXER,selector_lexer).
-define(PARSER,selector_parser).

-export([parse/1,parse/2]).
-export([matches/2]).

matches({predicate,{var,Var},Comparator,Critereon}, Props) ->
    case dict:is_key(Var,Props) of 
        false ->
            false;
        true ->    
            Value = dict:fetch(Var,Props),
            compare(Comparator, Value, Critereon)
    end;
matches({intersection,P1,P2}, Props) ->
    matches(P1,Props) andalso matches(P2,Props);
matches({union,P1,P2}, Props) ->
    matches(P1,Props) or matches(P2,Props);        
    
matches(_,_) -> false.

compare(memberof, Value,{list,List}) -> lists:member(Value,List);
compare('=', Value,Critereon) -> Value == Critereon;
compare('>', Value,Critereon) -> Value > Critereon;
compare('<', Value,Critereon) -> Value < Critereon;
compare('>=', Value,Critereon) -> Value >= Critereon;
compare('=<', Value,Critereon) -> Value =< Critereon;
compare(_,_,_) -> false.

parse(String) ->
    {ok,Tokens,EndLine} = ?LEXER:string(String),
    ?LOG("Tokens",Tokens),
    {ok, ParseTree} = ?PARSER:parse(Tokens),
    ParseTree.

parse(file, FileName) ->
    {ok, InFile} = file:open(FileName, [read]),
    Acc = loop(InFile,[]),
    file:close(InFile),
    selector_parser:parse(Acc).

loop(InFile,Acc) ->
    case io:request(InFile, {get_until,prompt,?LEXER,token,[1]}) of
        {ok,Toks,EndLine} ->
            loop(InFile,Acc ++ [Toks]);
        {error,token} ->
            exit("Scanning error");    
        {eof,_} ->
            Acc
    end.

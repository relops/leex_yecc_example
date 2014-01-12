-module(selector_test).

-include("selector.hrl").
-include_lib("eunit/include/eunit.hrl").

equals_test() ->
    Spec = selector:parse("A = 22"),
    TestData1 = dict:store('A',22,dict:new()),
    ?assert(selector:matches(Spec,TestData1)),
    TestData2 = dict:store('A',34,dict:new()),
    ?assertNot(selector:matches(Spec,TestData2)).

greater_than_test() ->
    Spec = selector:parse("A > 22"),
    TestData1 = dict:store('A',23,dict:new()),
    ?assert(selector:matches(Spec,TestData1)),
    TestData2 = dict:store('A',21,dict:new()),
    ?assertNot(selector:matches(Spec,TestData2)).
    
set_test() ->
    Spec = selector:parse("A in (22,33,44)"),
    TestData1 = dict:store('A',33,dict:new()),
    ?assert(selector:matches(Spec,TestData1)),
    TestData2 = dict:store('A',34,dict:new()),
    ?assertNot(selector:matches(Spec,TestData2)).
    
and_test() ->
    Spec = selector:parse("A in (22,33,44) and B in ('abc','xyz')"),
    TestData0 = dict:store('A',33,dict:new()),
    TestData1 = dict:store('B',"abc",TestData0),
    ?assert(selector:matches(Spec,TestData1)),
    TestData2 = dict:store('B',"abd",TestData0),
    ?assertNot(selector:matches(Spec,TestData2)).
    
or_test() ->
    Spec = selector:parse("A in (22,33,44) or B in ('abc','xyz')"),
    TestData0 = dict:store('A',34,dict:new()),
    TestData1 = dict:store('B',"xyz",TestData0),
    ?assert(selector:matches(Spec,TestData1)),
    TestData2 = dict:store('B',"xya",TestData0),
    ?assertNot(selector:matches(Spec,TestData2)).
% Andrew Pennebaker
% 6 Dec 2010 - 24 Feb 2011

-module(ios7crypt).
-author("andrew.pennebaker@gmail.com").
-export([encrypt/1, decrypt/1, main/1]).
-include_lib("triq/include/triq.hrl").
-import(getopt, [usage/2, parse/2]).
-import(lists, [nth/2, map/2, keymember/3, flatten/1, nthtail/2, any/2]).
-import(string, [concat/2, join/2, substr/3, to_integer/1]).
-import(crypto, [exor/2]).

-define(XlatLen, 53).
-define(Xlat, [
	16#64, 16#73, 16#66, 16#64, 16#3b, 16#6b, 16#66, 16#6f,
	16#41, 16#2c, 16#2e, 16#69, 16#79, 16#65, 16#77, 16#72,
	16#6b, 16#6c, 16#64, 16#4a, 16#4b, 16#44, 16#48, 16#53,
	16#55, 16#42, 16#73, 16#67, 16#76, 16#63, 16#61, 16#36,
	16#39, 16#38, 16#33, 16#34, 16#6e, 16#63, 16#78, 16#76,
	16#39, 16#38, 16#37, 16#33, 16#32, 16#35, 16#34, 16#6b,
	16#3b, 16#66, 16#67, 16#38, 16#37
]).

key(_, 0) -> [];
key(Seed, Length) -> [nth((Seed+1) rem ?XlatLen, ?Xlat) | key(Seed+1, Length-1)].

encrypt(Password) ->
	Seed = random:uniform(16)-1,
	Key = key(Seed, length(Password)),
	CipherText = binary_to_list(exor(Password, Key)),

	% io_lib:format needs to be flattened
	% per http://www.erlang.org/pipermail/erlang-questions/2007-August/028664.html
	Rest = flatten(map(fun(A) -> io_lib:format("~2.16.0b", [A]) end, CipherText)),

	concat(flatten(io_lib:format("~2.10.0b", [Seed])), Rest).

onlyPairs(Text) when length(Text) =< 3 -> [substr(Text, 1, 2)];
onlyPairs(Text) -> [substr(Text, 1, 2) | onlyPairs(substr(Text, 3, length(Text)))].

decrypt(Hash) when length(Hash) < 4 -> {ok, ""};
decrypt(Hash) ->
	FirstTwo = substr(Hash, 1, 2),

	FirstOneRaw = re:replace(FirstTwo, "^0", ""),

	FirstTemp = nthtail(1, FirstOneRaw),

	FirstOne = case is_binary(FirstTemp) of
		true -> binary_to_list(FirstTemp);
		false -> FirstOneRaw
	end,

	ToInt = (catch list_to_integer(FirstOne, 10)),

	case ToInt of
		badarg ->
			{error, invalid_hash};
		S ->
			H = onlyPairs(substr(Hash, 3, length(Hash))),

			CipherText = (catch map(fun(Pair) -> list_to_integer(Pair, 16) end, H)),

			case CipherText of
				{'EXIT', {badarg, _}} ->
					{error, invalid_hash};
				_ ->
					Key = key(S, length(CipherText)),
					{ok, binary_to_list(exor(CipherText, Key))}
			end
	end.

prop_reversible() ->
	?FORALL({Passwd}, {list(int())},

	case any(fun(X) -> X < 0 end, Passwd) of
		true -> true; % ignore non-ascii password input
		false -> case ios7crypt:decrypt(ios7crypt:encrypt(Passwd)) of
					{error, _} -> false;
					{ok, Passwd2} -> Passwd2 == Passwd
				end
	end).

option_spec() ->
	[
	%% {Name, ShortOpt, LongOpt, ArgSpec, HelpMsg}
	{encrypt, $e, "encrypt", string, "Encrypt a password"},
	{decrypt, $d, "decrypt", string, "Decrypt a hash"},
	{test, $t, "test", undefined, "Perform unit test"},
	{help, $h, "help", undefined, "Display usage information"}
	].

main([]) -> usage(option_spec(), escript:script_name());
main(Args) ->
	{A1, A2, A3} = now(),
	random:seed(A1, A2, A3),

	OptionSpec = option_spec(),
	case parse(OptionSpec, Args) of
		{ok, {Options, _}} ->
			case nth(1, Options) of
				{encrypt, Password} -> io:format("~s~n", [encrypt(Password)]);
				{decrypt, Hash} -> case decrypt(Hash) of
					{ok, Password} -> io:format("~s~n", [Password]);
					_ -> io:format("Invalid hash.~n")
				end;
				test -> triq:check(prop_reversible());
				help -> usage(option_spec(), escript:script_name())
			end;
		{error, _} ->
			usage(option_spec(), escript:script_name())
	end.
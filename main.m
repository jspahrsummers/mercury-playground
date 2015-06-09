:- module main.

:- interface.
:- import_module io.

:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module list.
:- import_module string.

main(!IO) :-
	io.read_char(Result, !IO),
	(
		Result = ok(Char),
		io.write_char(rot13(Char), !IO),
		main(!IO)
	;
		Result = eof,
		io.write_string("Bye!\n", !IO)
	;
		Result = error(ErrorCode),
		io.format("%s\n", [s(io.error_message(ErrorCode))], !IO)
	).

:- func rot13(char) = char.

rot13(CharIn) =
	(
		if is_upper(CharIn)
		then to_upper(rot13(to_lower(CharIn)))
		else if rot13_2(CharIn, ForwardChar)
		then ForwardChar
		else if rot13_2(BackwardChar, CharIn)
		then BackwardChar
		else CharIn
	).

:- pred rot13_2(char, char).
:- mode rot13_2(in, out) is semidet.
:- mode rot13_2(out, in) is semidet.

rot13_2('a', 'n').
rot13_2('b', 'o').
rot13_2('c', 'p').
rot13_2('d', 'q').
rot13_2('e', 'r').
rot13_2('f', 's').
rot13_2('g', 't').
rot13_2('h', 'u').
rot13_2('i', 'v').
rot13_2('j', 'w').
rot13_2('k', 'x').
rot13_2('l', 'y').
rot13_2('m', 'z').

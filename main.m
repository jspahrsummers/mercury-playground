:- module main.

:- interface.
:- import_module io.

:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module exception.
:- import_module list.
:- import_module string.

main(!IO) :-
	command_line_arguments(Files, !IO),
	with_each_file(echo_stream, Files, !IO).

:- pred echo_stream(string::in, io.input_stream::in, io::di, io::uo) is det.

echo_stream(File, Stream, !IO) :-
	io.format("======== %s ========\n", [s(File)], !IO),
	io.input_stream_foldl_io(Stream, io.write_char, Result, !IO),
	guard_res(Result),
	io.nl(!IO).

:- pred with_each_file(pred(string, io.input_stream, io, io), list(string), io, io).
:- mode with_each_file(in(pred(in, in, di, uo) is det), in, di, uo) is det.

with_each_file(_, [], !IO) :- true.
with_each_file(Callback, [File | Files], !IO) :-
	io.open_input(File, Result, !IO),
	guard_res(Result, Stream),

	Callback(File, Stream, !IO),
	io.close_input(Stream, !IO),

	with_each_file(Callback, Files, !IO).

:- pred guard_res(io.res(T)::in, T::out) is det.

guard_res(Result, Value) :-
	(
		Result = io.ok(Value)
	;
		Result = io.error(ErrorCode),
		throw(ErrorCode)
	).

:- pred guard_res(io.res::in) is det.

guard_res(Result) :-
	(
		Result = io.ok
	;
		Result = io.error(ErrorCode),
		throw(ErrorCode)
	).

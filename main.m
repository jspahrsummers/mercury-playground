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
	processFiles(Files, !IO).

:- pred processFiles(list(string)::in, io::di, io::uo) is det.

processFiles([], !IO) :- true.
processFiles([File | Files], !IO) :-
	io.format("======== %s ========\n", [s(File)], !IO),

	io.open_input(File, Resource, !IO),
	guard_res(Resource, Stream),

	io.input_stream_foldl_io(Stream, io.write_char, Result, !IO),
	guard_res(Result),

	io.close_input(Stream, !IO),
	io.nl(!IO),

	processFiles(Files, !IO).

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

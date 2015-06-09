:- module main.

:- interface.
:- import_module io.

:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module string.

main(!IO) :-
	command_line_arguments(Files, !IO),
	processFiles(Files, !IO).

:- pred processFiles(list(string)::in, io::di, io::uo) is det.

processFiles([], !IO) :- true.
processFiles([X | Xs], !IO) :-
	io.open_input(X, Resource, !IO),
	(
		Resource = io.ok(Stream),
		io.input_stream_foldl_io(Stream, io.write_char, Result, !IO),
		(
			if Result = io.error(ErrorCode)
			then logError(ErrorCode, !IO)
			else processFiles(Xs, !IO)
		),
		io.close_input(Stream, !IO)
	;
		Resource = io.error(ErrorCode),
		logError(ErrorCode, !IO)
	).

:- pred logError(error::in, io::di, io::uo) is det.

logError(ErrorCode, !IO) :-
	io.format("%s\n", [s(io.error_message(ErrorCode))], !IO).

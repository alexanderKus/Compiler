module main

import os
import lexer
import parser

fn main() {
	if os.args.len > 2 { eprintln("ERROR: TOO MANY ARGSUMENTS\n USAGE: v run . <filename>")}
	file_name := os.args[1]
	mut l := lexer.create_lexer(file_name) or { panic('ERROR: CANNOT CRAETE LEXER: ${err}') }
	body_stmt := parser.parse(l.tokenize())	
	print(body_stmt)
}

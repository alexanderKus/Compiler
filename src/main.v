module main

import lexer
import parser

fn main() {
	mut l := lexer.create_lexer('examples/example2.c')! // or { panic('ERROR: cannot create lexer') }
	body_stmt := parser.parse(l.tokenize())	
	print(body_stmt)
}

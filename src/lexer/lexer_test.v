module lexer

import json

fn test_create_lexer() {
	path := 'examples/example1.c'
	lexer := create_lexer(path)!
	assert lexer.source.len > 0
}

fn test_init_reserved_token_kind_lu() {
	lexer.init_reserved_token_kind_lu()
	assert reserved_token_kind_lu.len > 0
}

fn test_tokenzier() {
	data := '[{"kind":"int_kind","value":"int"},{"kind":"identifier_kind","value":"main"},{"kind":"left_paren_kind","value":"{"},{"kind":"void_kind","value":"void"},{"kind":"right_paren_kind","value":")"},{"kind":"left_bracket_kind","value":"{"},{"kind":"return_kind","value":"return"},{"kind":"number_kind","value":"69"},{"kind":"semi_colon_kind","value":";"},{"kind":"right_bracket_kind","value":"}"}]'
	tokens := json.decode([]Token, data)!

	path := 'examples/example1.c'
	mut lexer := create_lexer(path)!

	lexer.tokenize()
	assert lexer.tokens.len == tokens.len
	assert lexer.tokens == tokens
}
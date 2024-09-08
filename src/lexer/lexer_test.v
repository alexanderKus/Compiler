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

fn test_tokenzier_2() {
	data := '[{"kind":"number_kind","value":"12"},{"kind":"plus_kind","value":"+"},{"kind":"number_kind","value":"3"},{"kind":"multiply_kind","value":"*"},{"kind":"number_kind","value":"1"},{"kind":"semi_colon_kind","value":";"}]'
	tokens := json.decode([]Token, data)!

	path := 'examples/example2.c'
	mut lexer := create_lexer(path)!

	lexer.tokenize()
	assert lexer.tokens.len == tokens.len
	assert lexer.tokens == tokens
}

fn test_tokenzier_3() {
	data := '[{"kind":"number_kind","value":"12"},{"kind":"multiply_kind","value":"*"},{"kind":"number_kind","value":"3"},{"kind":"plus_kind","value":"+"},{"kind":"number_kind","value":"1"},{"kind":"semi_colon_kind","value":";"}]'
	tokens := json.decode([]Token, data)!

	path := 'examples/example3.c'
	mut lexer := create_lexer(path)!

	lexer.tokenize()
	assert lexer.tokens.len == tokens.len
	assert lexer.tokens == tokens
}

fn test_tokenzier_4() {
	data := '[{"kind":"int_kind","value":"int"},{"kind":"identifier_kind","value":"a"},{"kind":"assignment_kind","value":"="},{"kind":"number_kind","value":"5"},{"kind":"semi_colon_kind","value":";"},{"kind":"int_kind","value":"int"},{"kind":"identifier_kind","value":"b"},{"kind":"assignment_kind","value":"="},{"kind":"identifier_kind","value":"a"},{"kind":"multiply_kind","value":"*"},{"kind":"number_kind","value":"10"},{"kind":"semi_colon_kind","value":";"},{"kind":"bool_kind","value":"bool"},{"kind":"identifier_kind","value":"is_foo"},{"kind":"assignment_kind","value":"="},{"kind":"identifier_kind","value":"a"},{"kind":"greater_than_kind","value":">"},{"kind":"identifier_kind","value":"b"},{"kind":"semi_colon_kind","value":";"}]'
	tokens := json.decode([]Token, data)!

	path := 'examples/example4.c'
	mut lexer := create_lexer(path)!

	lexer.tokenize()
	assert lexer.tokens.len == tokens.len
	assert lexer.tokens == tokens
}
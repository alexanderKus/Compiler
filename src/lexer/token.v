module lexer

import regex

__global (
	reserved_token_kind_lu map[string]TokenKind 
)

pub enum TokenKind {
	eof_kind
	white_space_kind

	int_kind
	string_kind
	bool_kind
	void_kind
	return_kind
	true_kind
	false_kind

	left_paren_kind
	right_paren_kind
	left_bracket_kind
	right_bracket_kind
	equals_kind
	not_equals_kind
	less_than_kind
	greater_than_kind
	less_or_equals_kind
	greater_or_equals_kind
	assignment_kind
	semi_colon_kind
	plus_kind
	minus_kind
	multiply_kind
	devide_kind
	procent_kind
	and_kind
	or_kind
	not_kind

	identifier_kind
	number_kind
}

pub struct Token {
	pub:
		kind  TokenKind
		value string
}

pub struct TokenPattern {
	pub:
		reg  regex.RE
		kind TokenKind
}

pub fn create_token(kind TokenKind, value string) Token {
	return Token{
		kind:  kind,
		value: value
	}
}

pub fn (t Token) str() string {
	return 'Token: Kind:${t.kind}, Value: ${t.value}'
}

pub fn init_reserved_token_kind_lu() {
	reserved_token_kind_lu = {
		'int'    : TokenKind.int_kind
		'bool'   : TokenKind.bool_kind
		'string' : TokenKind.string_kind
		'void'   : TokenKind.void_kind
		'return' : TokenKind.return_kind
		'true'   : TokenKind.true_kind
		'false'  : TokenKind.false_kind
	}
}

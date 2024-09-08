module lexer

import regex

__global (
	reserved_token_kind_lu map[string]TokenKind 
)

pub enum TokenKind {
	eof_kind
	white_space_kind

	let_kind
	const_kind
	string_kind
	true_kind
	false_kind

	left_paren_kind
	right_paren_kind
	left_bracket_kind
	right_bracket_kind
	left_square_bracket_kind
	right_square_bracket_kind
	equals_kind
	not_equals_kind
	plus_equals_kind
	minus_equals_kind
	less_than_kind
	greater_than_kind
	less_or_equals_kind
	greater_or_equals_kind
	assignment_kind
	semi_colon_kind
	colon_kind
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
		'let'    : TokenKind.let_kind
		'const'  : TokenKind.const_kind
		'true'   : TokenKind.true_kind
		'false'  : TokenKind.false_kind
	}
}

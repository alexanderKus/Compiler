module lexer

fn test_create_token() {
	mut token := create_token(TokenKind.int_kind, '2')
	assert token.kind == TokenKind.int_kind
	assert token.value == '2'
}
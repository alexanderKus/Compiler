module lexer

fn test_create_token() {
	mut token := create_token(TokenKind.number_kind, '2')
	assert token.kind == TokenKind.number_kind
	assert token.value == '2'
}
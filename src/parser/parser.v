module parser

import lexer
import ast

struct Parser {
	tokens []lexer.Token
mut:
	pos    int
}

fn create_parser(tokens []lexer.Token) &Parser{
	return &Parser{
		tokens: tokens,
		pos: 0
	}
}

fn (mut p Parser) current_token() lexer.Token {
	return p.tokens[p.pos]
}

fn (mut p Parser) current_token_kind() lexer.TokenKind {
	return p.current_token().kind
}

fn (mut p Parser) advance() lexer.Token {
	tk := p.current_token()
	p.pos++
	return tk
}

fn (mut p Parser) has_token() bool {
	return p.pos < p.tokens.len
}

fn (mut p Parser) expect(kind lexer.TokenKind) lexer.Token {
	ctk := p.current_token_kind()
	if ctk != kind { panic('ERROR: EXPECTED ${kind}, BUT GOT: ${ctk}') }
	return p.advance()
}

pub fn parse(tokens []lexer.Token) &ast.BlockStmt {
	create_token_lookups()
	mut p := create_parser(tokens)
	mut body := []ast.Stmt{}

	for p.has_token() {
		body << parse_stmt(mut p)
	}

	return &ast.BlockStmt{
		body: body
	}	
}
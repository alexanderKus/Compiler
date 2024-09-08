module parser

import lexer
import ast
import os

pub fn parse_stmt(mut p Parser) ast.Stmt {
	if stmt_fn := stmt_lu[p.current_token_kind()] {
		return stmt_fn(mut p)
	}

	expression := parse_expr(mut p, BandingPower.default_bp)
	p.expect(lexer.TokenKind.semi_colon_kind)

	return ast.ExpressionStmt{ expression: expression }
}

pub fn parse_var_decl_stmt(mut p Parser) ast.Stmt {
	// NOTE: messy code, refactor this!
	debug_flag := os.getenv('DEBUG').int()
	is_const := p.advance().kind == lexer.TokenKind.const_kind
	var_name := p.expect(lexer.TokenKind.identifier_kind).value
	if p.current_token_kind() == lexer.TokenKind.colon_kind {
		p.advance()
		explicit_type := parse_type(mut p, BandingPower.default_bp)
		p.expect(lexer.TokenKind.assignment_kind)
		assiged_value := parse_expr(mut p, BandingPower.assignment)
		p.expect(lexer.TokenKind.semi_colon_kind)
		if debug_flag >= 3 { println('VarDeclStmt: name: ${var_name}, explicit_type: ${explicit_type}, is_const: ${false}, assiged_value: ${assiged_value}') }
		return ast.VarDeclStmt { variable_name: var_name is_constant: is_const assiged_value: assiged_value explicit_type: explicit_type }
	}
	if p.current_token_kind() != lexer.TokenKind.assignment_kind { panic('ERROR: CRAETED VARIBALE MUST HAVE VALUE OR TYPE!') }
	p.expect(lexer.TokenKind.assignment_kind)
	assiged_value := parse_expr(mut p, BandingPower.assignment)
	p.expect(lexer.TokenKind.semi_colon_kind)
	if debug_flag >= 3 { println('VarDeclStmt: name: ${var_name}, explicit_type: none, is_const: ${false}, assiged_value: ${assiged_value}') }
	return ast.VarDeclStmt { variable_name: var_name is_constant: is_const assiged_value: assiged_value }
}
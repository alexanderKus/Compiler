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
	tp := p.advance().kind // NOTE: based on token kind set is_contant
	var_name := p.expect(lexer.TokenKind.identifier_kind).value
	p.expect(lexer.TokenKind.assignment_kind)
	assiged_value := parse_expr(mut p, BandingPower.assignment)
	p.expect(lexer.TokenKind.semi_colon_kind)
	
	debug_flag := os.getenv('DEBUG').int()
	if debug_flag >= 3 { println('VarDeclStmt: name: ${var_name}, is_const: ${false}, assiged_value: ${assiged_value}') }

	return ast.VarDeclStmt {
		variable_name: var_name,
		is_constant: false,
		assiged_value: assiged_value
	}
}
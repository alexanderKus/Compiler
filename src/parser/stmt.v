module parser

import lexer
import ast

pub fn parse_stmt(mut p Parser) ast.Stmt {
	if stmt_fn := stmt_lu[p.current_token_kind()] {
		stmt_fn(mut p)
	}

	expression := parse_expr(mut p, BandingPower.default_bp)
	p.expect(lexer.TokenKind.semi_colon_kind)

	return ast.ExpressionStmt{ expression: expression }
}
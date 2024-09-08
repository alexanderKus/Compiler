module parser

import ast
import lexer
import os

pub fn parse_expr(mut p Parser, bp BandingPower) ast.Expr {
	mut tp := p.current_token_kind()
	nud_fn := nud_lu[tp] or { panic('ERROR: CANNOT GET NUD FUNC FOR TOKEN KIND: ${tp}, VALUE: ${p.current_token().value}') }
	mut left := nud_fn(mut p)

	for int(bp_lu[p.current_token_kind()]) > int(bp) {
		tp = p.current_token_kind()
		led_fn := led_lu[tp] or { panic('ERROR: CANNOT GET LED FUNC FOR TOKEN KIND: ${tp}, VALUE: ${p.current_token().value}') }
		left = led_fn(mut p, left, bp_lu[tp])
	}

	return left
}

pub fn parse_primary_expr(mut p Parser) ast.Expr {
	debug_flag := os.getenv('DEBUG').int()
	if debug_flag >= 3 { println('PrimaryExpr: kind: ${p.current_token_kind()} value: ${p.current_token().value}') }

	tk := p.current_token_kind()
	if tk == lexer.TokenKind.number_kind { return ast.NumberExpr{ value: p.advance().value.int() } }
	else if tk == lexer.TokenKind.string_kind { return ast.StringExpr{ value: p.advance().value } }
	else if tk == lexer.TokenKind.identifier_kind { return ast.SymbolExpr{ value: p.advance().value } }
	else { panic ("ERROR: UNSUPPORT TYPE") }
}

pub fn parse_binary_expr(mut p Parser, left ast.Expr, bp BandingPower) ast.Expr {
	operator := p.advance()
	// NOTE: in video was: right := parse_expr(mut p, BandingPower.default_bp)
	right := parse_expr(mut p, bp_lu[operator.kind])
	debug_flag := os.getenv('DEBUG').int()
	if debug_flag >= 3 { println('BinaryExpr: left: ${left}, operator: ${operator}, right: ${right}') }

	return ast.BinaryExpr{ left: left, operator: operator, right: right }
}

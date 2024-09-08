module parser

import ast
import lexer

pub enum BandingPower {
	default_bp
	comma
	assignment
	logical
	relational
	additive
	mulitipliative
	unary
	call
	member
	primary
}

type StmtHandler = fn (mut p Parser) ast.Stmt
type NudHandler  = fn (mut p Parser) ast.Expr
type LedHandler  = fn (mut p Parser, left ast.Expr, bp BandingPower) ast.Expr

type StmtLookUp = map[lexer.TokenKind]StmtHandler
type NudLookUp  = map[lexer.TokenKind]NudHandler
type LedLookUp  = map[lexer.TokenKind]LedHandler
type BpLookUp   = map[lexer.TokenKind]BandingPower

__global(
	stmt_lu StmtLookUp
	nud_lu  NudLookUp
	led_lu  LedLookUp
	bp_lu   BpLookUp
)

pub fn led(kind lexer.TokenKind, bp BandingPower, func LedHandler) {
	bp_lu[kind] = bp
	led_lu[kind] = func
}

pub fn nud(kind lexer.TokenKind, func NudHandler) {
	nud_lu[kind] = func
}

pub fn stmt(kind lexer.TokenKind, func StmtHandler) {
	bp_lu[kind] = BandingPower.default_bp
	stmt_lu[kind] = func
}

pub fn create_token_lookups() {
	led(lexer.TokenKind.and_kind, BandingPower.logical, parse_binary_expr)
	led(lexer.TokenKind.or_kind, BandingPower.logical, parse_binary_expr)

	led(lexer.TokenKind.less_than_kind, BandingPower.relational, parse_binary_expr)
	led(lexer.TokenKind.less_or_equals_kind, BandingPower.relational, parse_binary_expr)
	led(lexer.TokenKind.greater_than_kind, BandingPower.relational, parse_binary_expr)
	led(lexer.TokenKind.greater_or_equals_kind, BandingPower.relational, parse_binary_expr)
	led(lexer.TokenKind.equals_kind, BandingPower.relational, parse_binary_expr)
	led(lexer.TokenKind.not_equals_kind, BandingPower.relational, parse_binary_expr)

	led(lexer.TokenKind.plus_kind, BandingPower.additive, parse_binary_expr)
	led(lexer.TokenKind.minus_kind, BandingPower.additive, parse_binary_expr)

	led(lexer.TokenKind.multiply_kind, BandingPower.mulitipliative, parse_binary_expr)
	led(lexer.TokenKind.devide_kind, BandingPower.mulitipliative, parse_binary_expr)
	led(lexer.TokenKind.procent_kind, BandingPower.mulitipliative, parse_binary_expr)

	nud(lexer.TokenKind.number_kind, parse_primary_expr)
	nud(lexer.TokenKind.string_kind, parse_primary_expr)
	nud(lexer.TokenKind.identifier_kind, parse_primary_expr)


	stmt(lexer.TokenKind.int_kind, parse_var_decl_stmt)
	stmt(lexer.TokenKind.bool_kind, parse_var_decl_stmt)
}

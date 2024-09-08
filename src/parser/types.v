module parser

import ast
import lexer

type TypeNudHandler = fn (mut p Parser) ast.Type
type TypeLedHandler = fn (mut p Parser, left ast.Type, bp BandingPower) ast.Type

type TypeNudLookUp  = map[lexer.TokenKind]TypeNudHandler
type TypeLedLookUp  = map[lexer.TokenKind]TypeLedHandler
type TypeBpLookUp   = map[lexer.TokenKind]BandingPower

__global(
	type_nud_lu  TypeNudLookUp
	type_led_lu  TypeLedLookUp
	type_bp_lu   TypeBpLookUp
)

pub fn type_led(kind lexer.TokenKind, bp BandingPower, func TypeLedHandler) {
	type_bp_lu[kind] = bp
	type_led_lu[kind] = func
}

pub fn type_nud(kind lexer.TokenKind, func TypeNudHandler) {
	type_nud_lu[kind] = func
}

pub fn create_token_types_lookups() {
	type_nud(lexer.TokenKind.identifier_kind, parse_symbol_type)
	type_nud(lexer.TokenKind.left_square_bracket_kind, parse_array_type)
}

pub fn parse_type(mut p Parser, bp BandingPower) ast.Type {
	mut tp := p.current_token_kind()
	type_nud_fn := type_nud_lu[tp] or { panic('ERROR: CANNOT GET TYPE NUD FUNC FOR TOKEN KIND: ${tp}, VALUE: ${p.current_token().value}') }
	mut left := type_nud_fn(mut p)
	for int(type_bp_lu[p.current_token_kind()]) > int(bp) {
		tp = p.current_token_kind()
		type_led_fn := type_led_lu[tp] or { panic('ERROR: CANNOT GET TYPE LED FUNC FOR TOKEN KIND: ${tp}, VALUE: ${p.current_token().value}') }
		left = type_led_fn(mut p, left, type_bp_lu[tp])
	}
	return left
}

pub fn parse_symbol_type(mut p Parser) ast.Type {
	name := p.expect(lexer.TokenKind.identifier_kind).value
	return ast.SymbolType { name: name }
}

pub fn parse_array_type(mut p Parser) ast.Type {
	p.advance()
	p.expect(lexer.TokenKind.right_square_bracket_kind)
	underlying := parse_type(mut p, BandingPower.default_bp)
	return ast.ArrayType { underlying: underlying }
}

module ast 

import lexer

// LITERALS
pub struct NumberExpr {
	pub:
	value int
}

pub fn (ne NumberExpr) expr() {

}

pub struct StringExpr {
	pub:
	value string
}

pub fn (ne StringExpr) expr() {

}

pub struct SymbolExpr {
	pub:
	value string
}

pub fn (ne SymbolExpr) expr() {

}

// COMPLEX
pub struct BinaryExpr {
	pub:
	left     Expr
	operator lexer.Token
	right    Expr
}

pub fn (ne BinaryExpr) expr() {
}

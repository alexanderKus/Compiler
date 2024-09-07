module ast

pub struct BlockStmt {
	pub:
		body []Stmt
}

pub fn (bs BlockStmt) stmt() {

}

pub struct ExpressionStmt {
	pub:
		expression Expr
}

pub fn (bs ExpressionStmt) stmt() {

}
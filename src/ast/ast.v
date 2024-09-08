module ast

pub interface Stmt {
	stmt()
}

pub interface Expr {
	expr()
}

pub interface Type {
	type_()
}
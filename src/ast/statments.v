module ast

pub struct BlockStmt {
	pub:
	body []Stmt
}

pub fn (bs BlockStmt) stmt() { }

pub struct ExpressionStmt {
	pub:
	expression Expr
}

pub fn (bs ExpressionStmt) stmt() { }

pub struct VarDeclStmt {
	pub:
	variable_name string
	is_constant   bool
	assiged_value Expr
	explicit_type ?Type
}

pub fn (bs VarDeclStmt) stmt() { }

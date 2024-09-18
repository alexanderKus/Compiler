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
	assiged_value ?Expr
	explicit_type ?Type
}

pub fn (bs VarDeclStmt) stmt() { }

pub struct StructProperty {
	pub:
	// NOTE: if struct variable is static track it here
	type_ Type
}

pub struct StructMethod {
	//pub:
	// NOTE: if func is static track it here
	//type_ FnType // TODO: create this type
}

pub struct StructDeclStmt {
	pub:
	// public   bool
	struct_name string
	properties  map[string]StructProperty
	methods     map[string]StructMethod
}

pub fn (bs StructDeclStmt) stmt() { }

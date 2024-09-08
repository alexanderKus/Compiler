module ast

pub struct SymbolType {
	pub:
	name string
}

pub fn (sy SymbolType) type_() { }

pub struct ArrayType {
	pub:
	underlying Type
}

pub fn (sy ArrayType) type_() { }

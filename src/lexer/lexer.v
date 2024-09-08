module lexer

import os
import regex
import json

pub struct Lexer {
	source          string
mut:	
	tokens_patterns []TokenPattern
	tokens          []Token
	pos             int
}
 
pub fn create_lexer(path string) !Lexer {
	source := os.read_file(path) or {
    panic('ERROR: cannot read file at paht: ${path}')
  }

	init_reserved_token_kind_lu()
	return Lexer{
		source: source
		pos: 0
		tokens: []
		tokens_patterns: [
			TokenPattern{ regex.regex_opt(r'\s+')!, TokenKind.white_space_kind },
			TokenPattern{ regex.regex_opt(r'"[^"]*"')!, TokenKind.string_kind },
			TokenPattern{ regex.regex_opt(r'[a-zA-Z_][a-zA-Z0-9_]*')!, TokenKind.identifier_kind },
			TokenPattern{ regex.regex_opt(r'[0-9]+')!, TokenKind.number_kind },
			TokenPattern{ regex.regex_opt(r'==')!, TokenKind.equals_kind },
			TokenPattern{ regex.regex_opt(r'<=')!, TokenKind.less_or_equals_kind },
			TokenPattern{ regex.regex_opt(r'>=')!, TokenKind.greater_or_equals_kind },
			TokenPattern{ regex.regex_opt(r'<')!, TokenKind.less_than_kind },
			TokenPattern{ regex.regex_opt(r'>')!, TokenKind.greater_than_kind },
			TokenPattern{ regex.regex_opt(r'=')!, TokenKind.assignment_kind },
			TokenPattern{ regex.regex_opt(r'\(')!, TokenKind.left_paren_kind },
			TokenPattern{ regex.regex_opt(r'\)')!, TokenKind.right_paren_kind },
			TokenPattern{ regex.regex_opt(r'\{')!, TokenKind.left_bracket_kind },
			TokenPattern{ regex.regex_opt(r'\}')!, TokenKind.right_bracket_kind },
			TokenPattern{ regex.regex_opt(r';')!, TokenKind.semi_colon_kind },
			TokenPattern{ regex.regex_opt(r'\+')!, TokenKind.plus_kind },
			TokenPattern{ regex.regex_opt(r'\-')!, TokenKind.minus_kind },
			TokenPattern{ regex.regex_opt(r'\*')!, TokenKind.multiply_kind },
			TokenPattern{ regex.regex_opt(r'/')!, TokenKind.devide_kind },
			TokenPattern{ regex.regex_opt(r'%')!, TokenKind.procent_kind }
			TokenPattern{ regex.regex_opt(r'&&')!, TokenKind.procent_kind }
			TokenPattern{ regex.regex_opt(r'\|\|')!, TokenKind.procent_kind }
			TokenPattern{ regex.regex_opt(r'!')!, TokenKind.procent_kind }
		]
	}
}

fn (mut l Lexer) is_over() bool {
	return l.pos >= l.source.len
}

fn (mut l Lexer) advance(offset int) {
	l.pos += offset
}

fn (mut l Lexer) remainder() string {
	return l.source[l.pos..]
}

pub fn (mut l Lexer) tokenize() []Token{
	debug_flag := os.getenv('DEBUG').int()
	dump_tokens_flag := os.getenv("DTF").int()
	if debug_flag >= 1 { println('DEBUG: Tokenizer start') }
	for !l.is_over() {
		mut is_matched := false
		for tp in l.tokens_patterns {
			s, e := tp.reg.match_string(l.remainder())
			if s > -1 {
				is_matched = true
				mut t := Token{}
				if tp.kind ==  TokenKind.white_space_kind { l.advance(e) break }
				else if tp.kind == TokenKind.eof_kind { break } // NOTE: maybe need to create a OEF token
				else if tp.kind == TokenKind.string_kind { t = create_token(tp.kind, l.remainder()[s..e]) }
				else if tp.kind == TokenKind.identifier_kind { t = handle(tp.kind, l.remainder()[s..e]) }
				else if tp.kind == TokenKind.number_kind { t = create_token(tp.kind, l.remainder()[s..e]) }
				else if tp.kind == TokenKind.left_paren_kind { t = create_token(tp.kind, '{') }
				else if tp.kind == TokenKind.right_paren_kind { t = create_token(tp.kind, ')') }
				else if tp.kind == TokenKind.left_bracket_kind { t = create_token(tp.kind, '{') }
				else if tp.kind == TokenKind.right_bracket_kind { t = create_token(tp.kind, '}') }
				else if tp.kind == TokenKind.equals_kind { t = create_token(tp.kind, '==') }
				else if tp.kind == TokenKind.not_equals_kind { t = create_token(tp.kind, '!=') }
				else if tp.kind == TokenKind.less_than_kind { t = create_token(tp.kind, '<') }
				else if tp.kind == TokenKind.greater_than_kind { t = create_token(tp.kind, '>') }
				else if tp.kind == TokenKind.less_or_equals_kind { t = create_token(tp.kind, '<=') }
				else if tp.kind == TokenKind.greater_or_equals_kind { t = create_token(tp.kind, '>=') }
				else if tp.kind == TokenKind.assignment_kind { t = create_token(tp.kind, '=') }
				else if tp.kind == TokenKind.semi_colon_kind { t = create_token(tp.kind, ';') }
				else if tp.kind == TokenKind.plus_kind { t = create_token(tp.kind, '+') }
				else if tp.kind == TokenKind.minus_kind { t = create_token(tp.kind, '-') }
				else if tp.kind == TokenKind.multiply_kind { t = create_token(tp.kind, '*') }
				else if tp.kind == TokenKind.devide_kind { t = create_token(tp.kind, '/') }
				else if tp.kind == TokenKind.procent_kind { t = create_token(tp.kind, '%') }
				else if tp.kind == TokenKind.and_kind { t = create_token(tp.kind, '&&') }
				else if tp.kind == TokenKind.or_kind { t = create_token(tp.kind, '||') }
				else if tp.kind == TokenKind.not_kind { t = create_token(tp.kind, '!') }
				else { panic('ERROR: MISSING TOKEN TYPE IN IF STATEMENTS. KIND: ${tp.kind}') }
				if debug_flag >= 3 { println('DEBUG: s: ${s}, e: ${e}, kind: ${t.kind}, value: `${l.remainder()[s..e]}`') }
				l.tokens << t
				l.advance(e)
				break
			}
		}
		if !is_matched {
			panic("ERROR: valid token?, Source:`${l.remainder()}`")
		}
	}
	if dump_tokens_flag > 0 { println(json.encode(l.tokens)) }
	if debug_flag >= 2 { for t in l.tokens { println(t) } } 
	if debug_flag >= 1 { println('DEBUG: Tokenizer end') }
	return l.tokens.clone()
}

fn handle(kind TokenKind, value string) Token {
	if reserved_kind := reserved_token_kind_lu[value] {
		return Token{
			kind: reserved_kind,
			value: value
		}
	}
	return Token{
		kind: kind,
		value: value
	}
}

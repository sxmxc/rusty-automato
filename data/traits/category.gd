extends Resource

enum Type {ADDITIVE, SUBTRACTIVE}

export (String) var name
export (Resource) var stat_modified
export (int) var modify_amount
export (Type) var modify_type = Type.ADDITIVE

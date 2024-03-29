(parameter_definition name: (identifier) @variable.definition)
(declaration_definition variable: (identifier) @variable.definition)

(integer) @number.integer
(real) @number.float
(bool) @boolean
(power_number) @number.float
(quoted_string) @string
(comment) @comment


(elementary_type) @type
(basic_type) @type
(simple_set_type) @type.qualifier
(simple_range_type) @type.qualifier
(list_type) @type.qualifier
(simple_array_type) @type.qualifier
(set_declaration_or_expression name: (identifier) @variable.definition)

[
 "any"
] @type

[ "constant"
  "shared"
  "dynamic"
  "hashmap"
] @type.qualifier

[
 "function"
 "procedure"
] @keyword.function

[
 "or"
] @keyword.operatot

[
  "uses"
  "imports"
  "options"
  "version"
  "include"
] @keyword

[
  "parameters"
  "end-parameters"
  "model"
  "end-model"
  "declarations"
  "end-declarations"
  "record"
  "end-record"
] @function.builtin

(option) @string

; extends
(return_statement) @custom_expression.outer
(local_variable_declaration) @custom_expression.outer
(expression_statement) @custom_expression.outer
(if_statement) @custom_expression.outer
(while_statement) @custom_expression.outer
(enhanced_for_statement) @custom_expression.outer
(do_statement) @custom_expression.outer
(switch_expression) @custom_expression.outer
(for_statement) @custom_expression.outer
(explicit_constructor_invocation) @custom_expression.outer
(formal_parameters
  "," @_start .
  (spread_parameter) @parameter.inner
 (#make-range! "parameter.outer" @_start @parameter.inner))

(formal_parameters
  . (spread_parameter) @parameter.inner
  . ","? @_end
 (#make-range! "parameter.outer" @parameter.inner @_end))

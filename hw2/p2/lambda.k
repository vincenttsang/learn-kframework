// Copyright (c) 2012-2016 K Team. All Rights Reserved.

require "substitution.k"

module LAMBDA
  imports SUBSTITUTION

  syntax Val ::= Id
               | "lambda" Id "." Exp  [binder, latex(\lambda{#1}.{#2})]
  syntax Exp ::= Val
               | Exp Exp              [strict, left]
               | "(" Exp ")"          [bracket]
  syntax KVariable ::= Id
  syntax KResult ::= Val

  // rule for lambda
  rule (lambda X:Id . E:Exp) V:Val => E[V / X]

  syntax Val ::= Int | Bool
  syntax Exp ::= Exp "*" Exp          [strict, left]
               | Exp "/" Exp          [strict]
               > Exp "+" Exp          [strict, left]
               > Exp "<=" Exp         [strict]
  // rules for simple calculation
  rule I1 * I2 => I1 *Int I2
  rule I1 / I2 => I1 /Int I2
  rule I1 + I2 => I1 +Int I2
  rule I1 <= I2 => I1 <=Int I2

  syntax Exp ::= "if" Exp "then" Exp "else" Exp  [strict(1)]
  // rule for if else condition
  rule if true  then E else _ => E
  rule if false then _ else E => E

  syntax Exp ::= "let" Id "=" Exp "in" Exp
  // rule for let
  rule let X = E in E':Exp => (lambda X . E') E                        [macro]

  syntax Exp ::= "letrec" Id Id "=" Exp "in" Exp
               | "mu" Id "." Exp      [binder, latex(\mu{#1}.{#2})]
  // rule for letrec using mu
  rule letrec F:Id X = E in E' => let F = mu F . lambda X . E in E'    [macro]
  syntax Id ::= "$x" | "$y" | "$f"
  // new definition of mu through Y combinator
  rule mu X . E
  => (lambda $f . (
     (lambda $x . ($f (lambda $y . ($x $x $y))))
     (lambda $x . ($f (lambda $y . ($x $x $y))))
  )) (lambda X . E)
  // original definition using substitution
  //rule mu X . E => E[(mu X . E) / X]
endmodule

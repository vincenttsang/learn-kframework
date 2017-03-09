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

  rule (lambda X:Id . E:Exp) V:Val => E[V / X]

  syntax Val ::= Int | Bool
  syntax Exp ::= Exp "*" Exp          [strict, left]
               | Exp "/" Exp          [strict]
               > Exp "+" Exp          [strict, left]
               > Exp "<=" Exp         [strict]
  rule I1 * I2 => I1 *Int I2
  rule I1 / I2 => I1 /Int I2
  rule I1 + I2 => I1 +Int I2
  rule I1 <= I2 => I1 <=Int I2

  syntax Exp ::= "if" Exp "then" Exp "else" Exp  [strict(1)]
  rule if true  then E else _ => E
  rule if false then _ else E => E

  syntax Exp ::= "let" Id "=" Exp "in" Exp
  rule let X = E in E':Exp => (lambda X . E') E                        [macro]

  syntax Exp ::= "letrec" Id Id "=" Exp "in" Exp
               | "mu" Id "." Exp                 [binder, latex(\mu{#1}.{#2})]
  rule letrec F:Id X = E in E' => let F = mu F . lambda X . E in E'    [macro]
  rule mu X . E => E[(mu X . E) / X]

  syntax Exp ::= "callCC" Exp  [strict]
  syntax Val ::= CC(K)
  // I did this by dropping the K after callCC V so that we won't come back to K
  // two cases basically:
  // 1. when CC(K) is passed as param into lambda, the K will be dropped anyway
  // (even in the original callcc since finally when we come to evaluating
  // cc(K) V we will throw all things behind it including the original and add
  // the wrapped up K to the back to recover the context) thus
  // dropping K won't influence the case when we pass CC(K) as params
  // 2. when CC(K) is not passed as param, by dropping K we ensured that we will
  // never come back to the next of current context
  rule <k> (callCC V:Val => V CC(K)) ~> (K => .) </k>
  rule <k> CC(K) V ~> _ =>  V ~> K </k>
endmodule

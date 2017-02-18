module NB-SYNTAX
  // AExp: nv
  syntax AExp ::= "0"
              > "succ" AExp               //[strict]
              //> "pred" AExp               [strict]
  // BExp: v
  syntax BExp ::= Bool
              | AExp
              //| "(" BExp ")"               [bracket]
  // Stmt: t
  syntax Stmt ::= BExp
              | "(" Stmt ")"               [bracket]
              | "if" Stmt
                "then" Stmt "else" Stmt       [strict(1)]
              | "succ" Stmt                 [right, strict]
              | "pred" Stmt                 [right, strict]
              | "iszero" Stmt               [right, strict]
endmodule

module NB
  imports NB-SYNTAX
  // the result could be either nv or v
  syntax KResult ::= AExp | BExp

  //configuration <T color="yellow">
  //                <k color="green"> $PGM:Pgm </k>
  //                <state color="red"> .Map </state>
  //              </T>
  rule iszero 0 => true
  // problem
  rule iszero succ A:AExp => false
  rule pred 0 => 0
  rule pred succ A:AExp => A
  //we just don't need to labor for the succ one
  //rule succ AExp => succ AExp
  rule if true then B:BExp else _ => B
  rule if false then _ else B:BExp => B
endmodule

module IMP-SYNTAX
  syntax AExp  ::= Int | String | Id
                 | "++" Id
                 | "read" "(" ")"
                 > AExp "/" AExp              [left, strict, division]
                 > AExp "+" AExp              [left, strict]
                 > "spawn" Block
                 | "atomic" Block
                 > Id "=" AExp                [strict(2)]
                 | "(" AExp ")"               [bracket]
  syntax BExp  ::= Bool
                 | AExp "<=" AExp             [seqstrict, latex({#1}\leq{#2})]
                 | "!" BExp                   [strict]
                 > BExp "&&" BExp             [left, strict(1)]
                 | "(" BExp ")"               [bracket]
  syntax Block ::= "{" Stmts "}"
  syntax Stmt  ::= Block
                 | AExp ";"                   [strict]
                 | "if" "(" BExp ")"
                   Block "else" Block         [strict(1)]
                 | "while" "(" BExp ")" Block
                 | "int" Ids ";"
                 | "print" "(" AExps ")" ";"
                 | "halt" ";"
                 > "join" AExp ";"            [strict]

  syntax Ids   ::= List{Id,","}
  syntax AExps ::= List{AExp,","}
  syntax Stmts ::= List{Stmt,""}
endmodule


module IMP
  imports IMP-SYNTAX

  configuration <T color="yellow">
                  <threads color="orange">
                    <thread multiplicity="*" color="blue">
                      <k color="green"> $PGM:Stmts </k>
                      <env color="LightSkyBlue"> .Map </env>
                      <id color="black"> 0 </id>
                    </thread>
                  </threads>
//                <br/>
                  <store color="red"> .Map </store>
//                  <in color="magenta"> .List </in>
//                  <out color="Orchid"> .List </out>
                  <in color="magenta" stream="stdin"> .List </in>
                  <out color="Orchid" stream="stdout"> .List </out>
                </T>

  syntax KResult ::= Int | Bool

  rule <k> X:Id => I ...</k>
       <env>... X |-> N ...</env>
       <store>... N |-> I ...</store>  [lookup]

  rule I1 / I2 => I1 /Int I2  when I2 =/=Int 0
  rule I1 + I2 => I1 +Int I2

  rule I1 <= I2 => I1 <=Int I2
  rule ! T => notBool T
  rule true && B => B
  rule false && _ => false

  rule _:Int; => .
  rule <k> X = I:Int => I ...</k>
       <env>... X |-> N ...</env>
       <store>... N |-> (_ => I) ...</store>  [assignment]

   rule .Stmts => .
   rule S:Stmt Ss:Stmts => S ~> Ss  [structural]

  rule if (true)  S else _ => S
  rule if (false) _ else S => S

  rule while (B) S => if (B) {S while (B) S} else {.Stmts}  [structural]

  syntax KResult ::= String
  rule Str1 + Str2 => Str1 +String Str2

  rule <k> ++X => I +Int 1 ...</k>
       <env>... X |-> N ...</env>
       <store>... N |-> (I => I +Int 1) ...</store>  [increment]

  rule <k> read() => I ...</k>
       <in> ListItem(I:Int) => .List ...</in>  [read]

  syntax Printable ::= Int | String
  syntax AExp ::= Printable

  context print(HOLE:AExp, AEs:AExps);

  rule <k> print(P:Printable,AEs => AEs); ...</k>
       <out>... .List => ListItem(P) </out>  [print]
  rule print(.AExps); => .  [structural]

  rule <k> halt; ~> _ => . </k>
  rule <k> spawn S => !T:Int ...</k> <env> Rho </env>
       (.Bag => <thread>... <k> S </k> <env> Rho </env> <id> !T </id> ...</thread>)

  rule <k> join(T); => . ...</k> <thread>... <k>.</k> <id>T</id> ...</thread>

  rule <k> {Ss} => Ss ~> Rho ...</k> <env> Rho </env>  [structural]

  rule <k> int (X,Xs => Xs); ...</k>
       <env> Rho => Rho[X <- !N:Int] </env>
       <store>... .Map => !N |-> 0 ...</store>
  rule int .Ids; => .  [structural]

  rule <k> Rho => . ...</k> <env> _ => Rho </env>    [structural]

  // use ~> to wrap up current environment in a structural order
  //rule <k> atomic {Stmts} => Stmts ~> Rho ...</k> <env> Rho </env> [structural]
  // WORKS for deleting thread of certain id
  //rule <k> atomic S => 0 ...</k>
  //     (<thread>... <id> 1 </id> ...</thread> => .Bag) [structural]

  rule <thread>... <k> atomic S => !T:Int ...</k> <env> Rho </env> ...</thread>
       (.Bag => <thread>... <k> atomic S </k> <env> Rho </env> <id> !T </id> ...</thread>)
  rule <k> atomic S => S </k>

  //rule <k> atomic S => 0 ...</k>
  //     (<thread>... <id> 1 </id> ...</thread> => .Bag) [structural]
  // this rule works but it's within k ceil
  //rule <threads>... <thread>... <k> atomic S => .</k> ... </thread> ...</threads>

  // doesn't work
  //rule <threads>... <thread>... <k> atomic S => . ...</k> <env> Rho </env> ...</thread> ...</threads>
  //     => <threads> <thread> <k> S </k> <env> Rho </env> <id> !T:Int </id>
  //     </thread> </threads>
  //rule <k> atomic S => !T:Int ...</k> <env> Rho </env>
  //     (<threads> ...  </threads> =>
  //      <threads> <thread>... <k> S </k> <env> Rho </env> <id> !T </id> ...</thread> </threads>)
  // TODO freeze all other threads
endmodule

require "unification.k"

module LOGIK-COMMON
  syntax Literal
  syntax Term ::= Literal | Literal "(" Terms ")"
  syntax Terms ::= List{Term,","}
  syntax Clause ::= Term ":-" Terms "." | Term "."
  syntax Query ::= "?-" Terms "."
  syntax Pgm ::= Query | Clause Pgm
endmodule

module LOGIK-SYNTAX
  imports LOGIK-COMMON
    syntax Term ::= Token{[\_A-Z][a-zA-Z0-9\_]*}                   [variable, onlyLabel, autoReject, token]
    syntax Literal ::= Token{[a-z][a-zA-Z0-9\_]*}                  [onlyLabel, autoReject, token]
endmodule

module LOGIK
  imports UNIFICATION
  imports LOGIK-COMMON

  configuration <T color="yellow" multiplicity="?">
                  <k color="green"> $PGM:Pgm </k>
                  <fresh color="orange"> .K </fresh>
                  <clauses color="red">
                    <clause color="pink" multiplicity="*"> .K </clause>
                  </clauses>
                  <mgu> .K </mgu>
                </T>
                <solution multiplicity="?"> .K </solution>

  rule <k> C:Clause Pgm => Pgm </k>
       (.Bag => <clause> #renameVariables(C) </clause>)

  rule <k> ?- Ls:Terms. => Ls ...</k>
       <mgu> _ => #variablesMap(#variables(Ls)) </mgu>

  rule L:Term, Ls:Terms => L ~> Ls
  rule .Terms => .

rule <T>... <k> . </k> <mgu> Theta </mgu> ...</T>
  => <solution> Theta </solution>

  rule <fresh> . => #renameVariables(C) </fresh> <clause> C </clause>
       <k> T:Term ...</k>
  requires #unifiable(T,head(C))
    [transition]

  syntax Term ::= head(Clause) [function]
  rule head(L.) => L
  rule head(L:-_.) => L

  rule <k> L:Term => . ...</k>
       <fresh>  L:Term . => . </fresh>

  rule <k> L:Term => Ls ...</k>
       <fresh>  L:Term :- Ls:Terms. => . </fresh>

endmodule

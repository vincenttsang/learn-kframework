The directory for problem 2 is organized as follows

*-tests/
test programs for testing * syntax(callcc-small-tests for callcc, callCC for
callCC)
e.g. callcc-tests directory includes all the test programs (jump, no-jump, let,
return) for testing callcc syntax

substitution-based/
includes all solutions for substitution-based method, that is from subproblem 2.1
to 2.3
substitution-based/*
all sub directories here are built subproblem-wise, in which call-bigCC is for
subproblem 2.1 (defining callCC), bigCC-to-smallcc is for subproblem 2.2
(defining callcc in terms of callCC), smallcc-to-bigCC is for subproblem 2.3
(defining callCC in terms of callcc).

all sub sub directories here includes lambda.k which defines the syntax for the
corresponding sub problem, results file that showed the results I'm getting in
all test cases, test.sh as the script file to automatically run all test cases

env-based/
includes all solutions for environment-based approach, i.e., from subproblem 2.4
to 2.6
the naming of sub directories here follows the same rule as the
substitution-based style.


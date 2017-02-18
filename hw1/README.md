#Problem I
Modify the K definition of IMP to not automatically initialize
variables to `0`.  Instead, declared variables should stay uninitialized
until assigned a value, and the execution should get stuck when an
uninitialized variable is looked up.  Specifically, you should add a
new `undefined` construct of sort `K`, and initialize all the declared
variables with it.

#Problem II:
Add a variable increment construct, ++x (increment x and return the incremented
value), to IMP.

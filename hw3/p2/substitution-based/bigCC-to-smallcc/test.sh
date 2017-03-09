echo "From callCC to callcc, compiling"
kompile lambda.k
#echo "running callCC part:"
#krun ../callCC-tests/jump.lambda
#krun ../callCC-tests/no-jump.lambda
echo "runnning callcc part:"
krun ../../callcc-small-tests/jump.lambda
krun ../../callcc-small-tests/no-jump.lambda
krun ../../callcc-small-tests/callcc-return.lambda
krun ../../callcc-small-tests/callcc-let.lambda

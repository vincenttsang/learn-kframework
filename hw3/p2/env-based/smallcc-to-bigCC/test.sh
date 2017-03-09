echo "From callcc to callCC, compiling"
kompile lambda.k
#echo "running callCC part:"
#krun ../callCC-tests/jump.lambda
#krun ../callCC-tests/no-jump.lambda
echo "runnning callCC part:"
krun ../../callCC-tests/jump.lambda
krun ../../callCC-tests/no-jump.lambda
krun ../../callCC-tests/callCC-return.lambda
krun ../../callCC-tests/callCC-let.lambda

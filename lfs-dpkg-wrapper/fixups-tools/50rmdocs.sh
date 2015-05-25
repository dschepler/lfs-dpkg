for d in $packagedir/tools/{,share/}{info,man,doc}; do
    if [ -d $d ]; then
	doit "rm -rf $d"
    fi
done

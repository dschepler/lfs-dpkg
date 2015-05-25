case $(uname -m) in
x86_64)
    if [ -d $packagedir/tools/lib64 -a -z "$PRESERVE_LIB64" ]; then
	if [ -L $packagedir/tools/lib64 ]; then
	    doit "rm -f $packagedir/tools/lib64"
	else
	    doit "mkdir -pv $packagedir/tools/lib"
	    doit "mv -v $packagedir/tools/lib64/* $packagedir/tools/lib/"
	    doit "rmdir -v $packagedir/tools/lib64"
	fi
    fi
    ;;
esac

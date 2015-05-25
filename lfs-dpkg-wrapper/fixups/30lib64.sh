case $(uname -m) in
x86_64)
    if [ -d $packagedir/usr/lib64 -a -z "$PRESERVE_LIB64" ]; then
	if [ -L $packagedir/usr/lib64 ]; then
	    doit "rm -f $packagedir/usr/lib64"
	else
	    doit "mkdir -pv $packagedir/usr/lib"
	    doit "mv -v $packagedir/usr/lib64/* $packagedir/usr/lib/"
	    doit "rmdir -v $packagedir/usr/lib64"
	fi
    fi
    if [ -d $packagedir/lib64 -a -z "$PRESERVE_LIB64" ]; then
	if [ -L $packagedir/lib64 ]; then
	    doit "rm -f $packagedir/lib64"
	else
	    doit "mkdir -pv $packagedir/lib"
	    doit "mv -v $packagedir/lib64/* $packagedir/lib/"
	    doit "rmdir -v $packagedir/lib64"
	fi
    fi
    ;;
esac


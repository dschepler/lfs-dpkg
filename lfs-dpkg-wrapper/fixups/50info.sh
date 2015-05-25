if [ -f $packagedir/usr/share/info/dir ]; then
    doit "rm -f $packagedir/usr/share/info/dir"
fi

if [ -d $packagedir/usr/share/info ]; then
    for f in $packagedir/usr/share/info/*.info; do
        b=$(basename $f)
        if [ "$b" != "*.info" ]; then
	    doit "echo install-info /usr/share/info/$b --dir-file=/usr/share/info/dir >> $packagedir/DEBIAN/postinst"
	    doit "echo install-info --delete /usr/share/info/$b --dir-file=/usr/share/info/dir >> $packagedir/DEBIAN/prerm"
        fi
    done
fi

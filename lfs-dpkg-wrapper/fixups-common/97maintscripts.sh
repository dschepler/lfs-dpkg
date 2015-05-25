for f in preinst postinst prerm postrm; do
    if [ -f $packagedir/DEBIAN/$f ]; then
	if [ "$(head -n 1 $packagedir/DEBIAN/$f)" != '#!/bin/bash' ]; then
	    echo 'Prepend #!/bin/bash to $packagedir/DEBIAN/$f'
	    if [ "$dryrun" = 0 ]; then
		(echo '#!/bin/bash'; cat $packagedir/DEBIAN/$f) > $packagedir/DEBIAN/$f.tmp
		mv -f $packagedir/DEBIAN/$f.tmp $packagedir/DEBIAN/$f
	    fi
	fi
	if [ ! -x $packagedir/DEBIAN/$f ]; then
	    doit "chmod -v a+x $packagedir/DEBIAN/$f"
	fi
    fi
done

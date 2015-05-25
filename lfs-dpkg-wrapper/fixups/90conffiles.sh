if [ -d $packagedir/etc ]; then
    doit "(cd $packagedir; find etc -type f | sed -e 's:^:/:' >> DEBIAN/conffiles)"
    if [ ! -s $packagedir/DEBIAN/conffiles ]; then
	doit "rm -f $packagedir/DEBIAN/conffiles"
    fi
fi
	

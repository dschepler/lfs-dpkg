if [ -d $packagedir/tools/etc ]; then
    doit "(cd $packagedir; find tools/etc -type f | sed -e 's:^:/:' >> DEBIAN/conffiles)"
    if [ ! -s $packagedir/DEBIAN/conffiles ]; then
	doit "rm -f $packagedir/DEBIAN/conffiles"
    fi
fi

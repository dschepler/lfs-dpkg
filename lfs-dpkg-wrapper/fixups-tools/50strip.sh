if [ -d $packagedir/tools/lib ]; then
    doit "strip --strip-debug $packagedir/tools/lib/*"
fi
if [ -d debian/tmp/tools/bin ]; then
    doit "strip --strip-unneeded $packagedir/tools/bin/*"
fi
if [ -d debian/tmp/tools/sbin ]; then
    doit "strip --strip-unneeded $packagedir/tools/sbin/*"
fi

createcontrol() {
    if [ "$dryrun" = 1 ]; then
	echo "Would create $packagedir/DEBIAN/control with contents:"
	cat
    else
	echo "Creating $packagedir/DEBIAN/control with contents:"
	tee $packagedir/DEBIAN/control
    fi
}

createcontrol <<EOF
Package: $package
Version: $version
Maintainer: Linux From Scratch
Architecture: $arch
Description: LFS $package
EOF

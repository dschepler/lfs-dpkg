if [ -f $packagedir/DEBIAN/postinst ] &&
       grep -q ldconfig $packagedir/DEBIAN/postinst; then
    return
fi

find $packagedir -type f |
    while read f; do
	case "$(file --brief $f)" in
	    ELF*shared\ object*)
		doit "echo ldconfig >> $packagedir/DEBIAN/postinst"
		doit "echo ldconfig >> $packagedir/DEBIAN/postrm"
		return
		;;
	esac
    done

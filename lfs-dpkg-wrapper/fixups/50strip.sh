find $packagedir -type f |
    while read f; do
	case "$(file --brief $f)" in
	    ELF*executable*,\ not\ stripped | \
	    ELF*shared\ object*,\ not\ stripped)
		doit "strip --strip-unneeded $f" ;;
	    current\ ar\ archive)
		doit "strip --strip-debug $f" ;;
	esac
    done

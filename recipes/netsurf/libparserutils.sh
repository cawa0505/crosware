rname="libparserutils"
rver="0.2.4"
rdir="${rname}-${rver}"
rfile="${rdir}-src.tar.gz"
rurl="http://download.netsurf-browser.org/libs/releases/${rfile}"
rsha256="322bae61b30ccede3e305bf6eae2414920649775bc5ff1d1b688012a3c4947d8"
rreqs="make pkgconfig perl bison flex byacc reflex expat"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/netsurf/netsurf.sh.common"

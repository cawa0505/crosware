#
# XXX - alpine patches: https://git.alpinelinux.org/aports/tree/main/openssh
#

rname="openssh"
rver="8.0p1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/${rfile}"
rsha256="bd943879e69498e8031eb6b7f44d08cdc37d59a7ab689aa0b437320c3481fd68"
rreqs="make zlib openssl netbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --without-pie \
    --with-libedit=\"${cwsw}/netbsdcurses/current\" \
    --sysconfdir=\"${rtdir}/etc\" \
      CPPFLAGS=\"-I${cwsw}/zlib/current/include -I${cwsw}/openssl/current/include -I${cwsw}/netbsdcurses/include\" \
      LDFLAGS=\"-static -L${cwsw}/zlib/current/lib -L${cwsw}/openssl/current/lib -L${cwsw}/netbsdcurses/current/lib\" \
      LIBS='-lcrypto -lz -lcrypt -ledit -lcurses -lterminfo'
  popd >/dev/null 2>&1
}
"

eval "
function cwuninstall_${rname}() {
  pushd \"${rtdir}\" >/dev/null 2>&1
  rm -rf ${rname}-* current previous
  rm -f \"${rprof}\"
  rm -f \"${cwvarinst}/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
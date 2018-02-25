rname="perl"
rver="5.26.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.cpan.org/src/5.0/${rfile}"
rsha256="e763aa485e8dc1a70483dbe6d615986bbf32b977f38016480d68c99237e701dd"
rprof="${cwetcprofd}/${rname}.sh"
rreqs="make toybox busybox byacc"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${cwbuild}/${rdir}" >/dev/null 2>&1
  sttop=\"\$(realpath \$(dirname \$(realpath \$(which \${CC})))/..)\"
  stinc="\${sttop}/\${CC//-gcc/}/include"
  stbin="\${sttop}/bin"
  stlib="\${sttop}/\${CC//-gcc/}/lib"
  mkdir -p sysroot/usr
  ln -sf \${stbin} sysroot/usr/bin
  ln -sf \${stinc} sysroot/usr/include
  ln -sf \${stlib} sysroot/usr/lib
  ln -sf \${stbin} sysroot/bin
  ln -sf \${stlib} sysroot/lib
  ./Configure -des \
    -Dinstallusrbinperl='undef' \
    -Dso='none' \
    -Ddlext='none' \
    -Dusedl='n' \
    -Dprefix="${cwsw}/${rname}/${rdir}" \
    -Dsysroot="\${PWD}/sysroot" \
    -Dlibc="\${stlib}/libc.a" \
    -Dcc=\"\${CC} \${CFLAGS} \${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path "${cwsw}/${rname}/current/bin"' > "${rprof}"
}
"

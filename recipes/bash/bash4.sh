rname="bash4"
rver="4.4.23"
rdir="${rname%4}-${rver%.*}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname%4}/${rfile}"
rsha256="d86b3392c1202e8ff5a423b302e6284db7f8f435ea9f39b5b1b20fd3ac36dfcb"
rreqs="make byacc reflex flex bison sed netbsdcurses"
# patches file
bpfile="${cwrecipe}/${rname%4}/${rname}.patches"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${cwdl}/${rname}/${rfile}\" \"${rsha256}\"
  local p u f s
  if [ -e \"${bpfile}\" ] ; then
    for p in \$(cat ${bpfile}) ; do
      u=\${p%%,*}
      f=\"${cwdl}/${rname}/\$(basename \${u})\"
      s=\${p##*,}
      cwfetchcheck \"\${u}\" \"\${f}\" \"\${s}\"
    done
  fi
  unset f u p s
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local p
  if [ -e \"${bpfile}\" ] ; then
    cut -f1 -d, ${bpfile} | while read -r p ; do
      p=\"${cwdl}/${rname}/\$(basename \${p})\"
      patch -p0 < \"\${p}\"
    done
  fi
  unset p
  ./configure ${cwconfigureprefix} \
    --disable-nls \
    --disable-separate-helpfiles \
    --enable-readline \
    --enable-static-link \
    --without-bash-malloc \
    --with-curses \
      CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
      LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib/ -static\" \
      LIBS=\"-L${cwsw}/netbsdcurses/current/lib/ -lcurses -lterminfo\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  # ganked from alpine
  #  https://git.alpinelinux.org/cgit/aports/tree/main/bash/APKBUILD
  make y.tab.c
  make -j${cwmakejobs} builtins/libbuiltins.a
  make -j${cwmakejobs}
  make strip
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  install -m 0755 bash \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/${rname%4}\"
  ln -sf \"${rtdir}/current/bin/${rname%4}\" \"${ridir}/bin/sh\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

unset bpfile

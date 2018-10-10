rname="glib"
rver="2.58.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="http://ftp.gnome.org/pub/gnome/sources/glib/${rver%.*}/${rfile}"
rsha256="97d6a9d926b6aa3dfaadad3077cfb43eec74432ab455dff14250c769d526d7d6"
rreqs="gettexttiny libffi make perl pkgconfig python2 zlib autoconf automake libtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  cat > gtk-doc.make <<EOF
EXTRA_DIST =
CLEANFILES =
EOF
  touch INSTALL
  env PATH=\"${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:${PATH}\" \
    autoreconf -fiv -I${cwsw}/libtool/current/share/aclocal -I${cwsw}/pkgconfig/current/share/aclocal
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --with-pcre=internal \
    --disable-libmount \
    --disable-gtk-doc \
    --disable-compile-warnings \
    --disable-fam \
    --with-python=\"${cwsw}/python2/current/bin/python2.7\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"

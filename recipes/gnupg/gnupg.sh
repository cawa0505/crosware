rname="gnupg"
rver="2.2.19"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="242554c0e06f3a83c420b052f750b65ead711cc3fddddb5e7274fcdbb4e9dec0"
rreqs="make libgpgerror libgcrypt libksba libassuan npth ntbtls sqlite readline ncurses slibtool zlib bzip2 pkgconfig pinentry"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/libgpgerror/current/bin:${cwsw}/libgcrypt/current/bin:${cwsw}/libassuan/current/bin:${cwsw}/libksba/current/bin:${cwsw}/npth/current/bin:${cwsw}/ntbtls/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} \
      --disable-ccid-driver \
      --disable-gnutls \
      --disable-ldap \
      --disable-nls \
      --enable-ntbtls \
      --with-libgpg-error-prefix=\"${cwsw}/libgpgerror/current\" \
      --with-libgcrypt-prefix=\"${cwsw}/libgcrypt/current\" \
      --with-libassuan-prefix=\"${cwsw}/libassuan/current\" \
      --with-ksba-prefix=\"${cwsw}/libksba/current\" \
      --with-npth-prefix=\"${cwsw}/npth/current\" \
      --with-ntbtls-prefix=\"${cwsw}/ntbtls/current\" \
      --with-bzip2=\"${cwsw}/bzip2/current\" \
      --with-readline=\"${cwsw}/readline/current\" \
      --with-zlib=\"${cwsw}/zlib/current\" \
      --with-pinentry-pgm=\"${cwsw}/pinentry/current/bin/pinentry\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"

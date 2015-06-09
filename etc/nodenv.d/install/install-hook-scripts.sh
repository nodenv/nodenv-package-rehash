after_install install_hook_scripts

install_hook_scripts() {

  echo "RUN INSTALL OF HOOK SCRIPTS" $PREFIX
  "${BASH_SOURCE%/*}"/../bin/install.sh "$PREFIX"

}

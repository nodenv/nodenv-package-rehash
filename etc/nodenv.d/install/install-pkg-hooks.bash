after_install install_hook_scripts

install_hook_scripts() {

  echo "RUN INSTALL OF HOOK SCRIPTS $NODENV_VERSION"
  nodenv-install-pkg-hooks "$NODENV_VERSION"

}

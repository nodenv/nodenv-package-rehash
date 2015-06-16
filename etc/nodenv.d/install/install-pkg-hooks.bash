after_install install_hook_scripts

install_hook_scripts() {

  nodenv-package-hooks install "$NODENV_VERSION"
  echo "Installed postinstall/postuninstall package hooks for $NODENV_VERSION"

}

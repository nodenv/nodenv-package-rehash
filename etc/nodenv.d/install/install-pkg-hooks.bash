after_install install_hook_scripts

install_hook_scripts() {
  nodenv-package-hooks install "$VERSION_NAME"
  echo "Installed postinstall/postuninstall package hooks for $VERSION_NAME"
}

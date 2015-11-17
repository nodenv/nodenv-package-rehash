after_install install_hook_scripts

install_hook_scripts() {
  if [ "$STATUS" != 0 ]; then return; fi

  nodenv-package-hooks install "$VERSION_NAME"
  echo "Installed postinstall/postuninstall package hooks for $VERSION_NAME"
}

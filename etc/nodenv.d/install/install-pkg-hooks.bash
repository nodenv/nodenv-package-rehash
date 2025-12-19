# shellcheck shell=bash

after_install install_hook_scripts
after_install warn_buggy_npm

install_hook_scripts() {
  # only install hooks after successfull node installation
  [ "$STATUS" = 0 ] || return

  nodenv-package-hooks install "$VERSION_NAME"
  echo "Installed postinstall/postuninstall package hooks for $VERSION_NAME"
}

buggy_npm_version() {
  # v8.2.0 - v10.2.1
  local bad_versions='^((8\.([2-9]|10|11))|9|(10\.[0-2])\.)'

  [[ "$VERSION_NAME" =~ $bad_versions ]]
}

warn_buggy_npm() {
  ! buggy_npm_version || cat <<-MSG

WARNING: Automatic rehashing provided by nodenv-package-rehash will not
function correctly for this node version unless you upgrade npm >=6.1.0.
    NODENV_VERSION=$VERSION_NAME npm i -g npm@latest
Otherwise, you will need to run \`nodenv rehash' manually after installing
global packages. see https://github.com/nodenv/nodenv-package-rehash/issues/22
(This node bundles a buggy npm that doesn't execute global hooks.)

MSG
}

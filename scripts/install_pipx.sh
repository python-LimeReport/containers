#!/usr/bin/env bash

python3 -m pip install pipx 
python3 -m pipx ensurepath

source "$HOME/.bashrc"

# 
# cat <<EOF > /usr/local/bin/pipx
# #!/bin/bash
# 
# set -euo pipefail
# 
# if [ \$(id -u) -eq 0 ]; then
# 	export PIPX_HOME=/opt/_internal/pipx
# 	export PIPX_BIN_DIR=/usr/local/bin
# fi
# ${TOOLS_PATH}/bin/pipx "\$@"
# EOF
# chmod 755 /usr/local/bin/pipx
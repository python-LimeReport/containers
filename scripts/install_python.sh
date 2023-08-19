#!/usr/bin/env bash

PYTHON_INSTALL_PATH="${INSTALLPATH:-"/usr/local/python"}"
CURRENT_PATH="${PYTHON_INSTALL_PATH}/current"

find_version_from_git_tags() {
    local variable_name=$1
    local requested_version=${!variable_name}
    if [ "${requested_version}" = "none" ]; then return; fi
    local repository=$2
    local prefix=${3:-"tags/v"}
    local separator=${4:-"."}
    local last_part_optional=${5:-"false"}    
    if [ "$(echo "${requested_version}" | grep -o "." | wc -l)" != "2" ]; then
        local escaped_separator=${separator//./\\.}
        local last_part
        if [ "${last_part_optional}" = "true" ]; then
            last_part="(${escaped_separator}[0-9]+)?"
        else
            last_part="${escaped_separator}[0-9]+"
        fi
        local regex="${prefix}\\K[0-9]+${escaped_separator}[0-9]+${last_part}$"
        local version_list="$(git ls-remote --tags ${repository} | grep -oP "${regex}" | tr -d ' ' | tr "${separator}" "." | sort -rV)"
        if [ "${requested_version}" = "latest" ] || [ "${requested_version}" = "current" ] || [ "${requested_version}" = "lts" ]; then
            declare -g ${variable_name}="$(echo "${version_list}" | head -n 1)"
        else
            set +e
            declare -g ${variable_name}="$(echo "${version_list}" | grep -E -m 1 "^${requested_version//./\\.}([\\.\\s]|$)")"
            set -e
        fi
    fi
    if [ -z "${!variable_name}" ] || ! echo "${version_list}" | grep "^${!variable_name//./\\.}$" > /dev/null 2>&1; then
        echo -e "Invalid ${variable_name} value: ${requested_version}\nValid values:\n${version_list}" >&2
        exit 1
    fi
    echo "${variable_name}=${!variable_name}"
}

add_symlink() {
    if [[ ! -d "${CURRENT_PATH}" ]]; then
        ln -s -r "${INSTALL_PATH}" "${CURRENT_PATH}" 
    fi

    if [ "${OVERRIDE_DEFAULT_VERSION}" = "true" ]; then
        if [[ $(ls -l ${CURRENT_PATH}) != *"-> ${INSTALL_PATH}"* ]] ; then
            rm "${CURRENT_PATH}"
            ln -s -r "${INSTALL_PATH}" "${CURRENT_PATH}" 
        fi
    fi
}

VERSION="3.9"

find_version_from_git_tags VERSION "https://github.com/python/cpython"

mkdir -p /tmp/python-src
cd /tmp/python-src
tgz_filename="Python-${VERSION}.tgz"
tgz_url="https://www.python.org/ftp/python/${VERSION}/${tgz_filename}"
echo "Downloading ${tgz_filename}..."
curl -sSL -o "/tmp/python-src/${tgz_filename}" "${tgz_url}"
tar -xzf "/tmp/python-src/${tgz_filename}" -C "/tmp/python-src" --strip-components=1
cd /tmp/python-src
./configure --enable-optimizations
make -j "$(nproc)" install
alias python=/usr/local/bin/python3
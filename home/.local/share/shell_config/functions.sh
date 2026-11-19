#!/usr/bin/env bash
# shellcheck disable=2164,2155

function xdocker() {
    docker run \
        -it \
        --rm \
        --user "$(id -u)":"$(id -g)" \
        --userns=host \
        --net=host \
        --ipc=host \
        -e DISPLAY="$DISPLAY" \
        -v /tmp/.X11-unix/:/tmp/.X11-unix:ro \
        -v "${HOME}/.Xauthority:/home/$(whoami)/.Xauthority:ro" \
        -v /etc/passwd:/etc/passwd:ro \
        -v /etc/group:/etc/group:ro \
        "$@"
}

# Create a Python virtual environment in a temporary directory
function tmpvenv() {
    if [ $# -lt 1 ] || [ ! -f "$1" ]; then
        echo "usage: tmpvenv requirements.txt [venv ARGS]"
        return
    fi

    local requirements=$1
    shift
    export TMPVENV_DIR=$(mktemp -d)

    # shellcheck source=/dev/null
    python -m venv "$@" "${TMPVENV_DIR}" && \
    source "${TMPVENV_DIR}"/bin/activate && \
    pip install -r "${requirements}"
}

function external_monitor_1080p() {
    xrandr --output DP-1 --off
    xrandr --output eDP-1 --scale "0.9999x0.9999" \
           --output DP-1 --auto --scale 2x2 --right-of eDP-1
}

function find_static_symbol() {
    fd '.*\.a$' -x bash -c "nm --defined-only {} 2>/dev/null | grep \"$1\" && echo {}"
}

function find_dynamic_symbol() {
    scanelf -ls +"$1" | grep "$1"
}

function search_dynamic_symbol() {
    (cd /usr/lib && fd -i ".*${1}.*\.so" -x bash -c "nm --dynamic --with-symbol-versions --defined-only {} 2>/dev/null | rg -i \"$2\" && echo {}")
}

function gperftools_heap_profiler() {
    echo "Visualise profiling data with \`pprof --gv heap_profile.xxxx.hprof\`"
    env \
        LD_PRELOAD=/usr/lib/libtcmalloc.so \
        HEAPPROFILE="$(pwd)"/heap_profile.hprof \
        "$@"
}

function gdb_attach() {
    if [ "$(cat /proc/sys/kernel/yama/ptrace_scope)" -ne 0 ]; then
        echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    fi
    local bin=$1
    shift
    gdb -q "$bin" "$(pgrep "$bin")" "$@"
}

function gif_args() {
    if [ $# -ne 3 ]; then
        echo "Usage: gif_args <width> <fps> <speedup>"
        return 1
    fi
    echo -vf "fps=${2:-12},scale=${1:-600}:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse,setpts=$(echo "scale=2; 1/${3:-1}" | bc)*PTS" -loop 0
}

function compare_dirs() {
    python -c "import filecmp; filecmp.dircmp('${1}', '${2}').report_full_closure()"
}

function rgsed() {(
    set -euo pipefail
    pattern=${1//\//\\\/}
    replacement=${2//\//\\\/}
    grep_cmd='grep -lERZ'

    if command -v rg &>/dev/null ; then
        grep_cmd='rg -l0'
    fi

    eval "${grep_cmd} '$1' | xargs -0l sed -Ei 's/${pattern}/${replacement}/g'"
)}

# https://stackoverflow.com/a/17841619
function strjoin() {(
    set -euo pipefail

    delimiter=${1:-}
    first_entry=${2:-}

    if shift 2 ; then
        printf "%s" "${first_entry}" "${@/#/$delimiter}"
    else
        echo "Usage: strjoin delimiter str1 [strn ...]"
    fi
)}

function trim_whitespace() {(
    set -euo pipefail

    awk '{$1=$1; print}' < /dev/stdin
)}

function wait_for_network() {(
    while ! nc -zw1 8.8.8.8 443 &>/dev/null ; do
        sleep 2
    done
)}

# Since Vista, Windows is always installed in <drive>:\Windows, only the drive varies
function _find_windows_dir() {(
    set -euo pipefail

    while read -r mount_point; do
        if [[ -e "${mount_point}/Windows/System32/cmd.exe" ]]; then
            echo "${mount_point}/Windows"
            return 0
        fi
    done < <(awk '$3 == "drvfs" || ($3 == "9p" && $4 ~ /aname=drvfs/) {print $2}' /proc/mounts)
    return 1
)}

# WSL already sets the Windows path via appendWindowsPath, but sessions not started
# through WSL interop lack it
function append_windows_path() {
    local windows_dir
    windows_dir=$(_find_windows_dir) || return 1

    # Windows paths are case insensitive and may have trailing slashes
    local normalized_path
    normalized_path=$(tr ':' '\n' <<< "${PATH}" | sed 's,/*$,,')

    local dir
    for dir in \
            "${windows_dir}" \
            "${windows_dir}/System32" \
            "${windows_dir}/System32/Wbem" \
            "${windows_dir}/System32/WindowsPowerShell/v1.0" \
            "${windows_dir}/System32/OpenSSH" \
            "${windows_dir%/*}/Program Files/PowerShell/7"; do
        if [[ -d "${dir}" ]] && ! grep -qixF -- "${dir}" <<< "${normalized_path}"; then
            export PATH="${PATH}:${dir}"
        fi
    done
}

# Only manages the local agent, so that local keys never end up in a forwarded one
function ensure_ssh_agent() {
    if [[ "${SSH_AUTH_SOCK:-}" != "${SSH_AGENT_SOCKET}" ]]; then
        return 0
    fi

    local added_ssh_keys
    added_ssh_keys=$(ssh-add -l 2> /dev/null)
    if [[ $? -eq 2 ]]; then
        # A killed agent leaves its socket behind, blocking a new one from binding it
        rm -f "${SSH_AGENT_SOCKET}"
        ssh-agent -a "${SSH_AGENT_SOCKET}" > /dev/null
    fi

    local key
    for key in "${SSH_KEYS_TO_ADD[@]}"; do
        if [[ -f "${key}" ]] && ! grep -qF -- "$(ssh-keygen -lf "${key}" | awk '{print $2}')" \
                <<< "${added_ssh_keys}"; then
            ssh-add "${key}" < /dev/null
        fi
    done
}

function get_windows_secret() {
    powershell.exe -Command "Get-Secret -Name ${1} -AsPlainText" < /dev/null | tr -d '\r'
}

function set_windows_secret() {(
    set -euo pipefail

    if [[ -t 0 ]]; then
        printf 'Secret for %s: ' "${1}" >&2
    fi
    IFS= read -rs secret || true
    if [[ -t 0 ]]; then
        echo >&2
    fi

    printf '%s' "${secret}" | base64 -w 0 | powershell.exe -Command "
        \$secret = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String([Console]::In.ReadToEnd()))
        Set-Secret -Name ${1} -Secret \$secret"
)}

function remove_windows_secret() {
    powershell.exe -Command \
        "Remove-Secret -Name ${1} -Vault (Get-SecretVault | Where-Object IsDefault).Name" < /dev/null
}

function get_python_secret() {
    keyring get "$2" "$1"
}

function read_passwd() {
    if [ -z "${PASSWD:-}" ]; then
        PASSWD=$(${PASSWD_GETTER} "${PASSWD_USER}" "${PASSWD_FOLDER}")
        export PASSWD
    fi
    if [ -z "${PASSWD:-}" ]; then
        read -rs "PASSWD?[zshenv] password for $USER: "
        echo
        export PASSWD
    fi
}

function script_sudo() {(
    set -euo pipefail

    read_passwd
    echo "$PASSWD" | sudo --prompt '' --stdin "${@}"
)}

function explorer() {(
    set -euo pipefail
    explorer.exe "$(wslpath -w "$1")"
)}


function recheck_chain() {(
    set -euo pipefail

    chain_end=${1:-HEAD}
    commit=$(git rev-parse "${chain_end}")

    while true; do
        commit_status=$(
            ssh -p "${GERRIT_PORT}" "${GERRIT_HOST}" \
                gerrit query commit:"${commit}" status:merged \
                | awk '/^rowCount:/ {print $2}'
        )

        if [[ "${commit_status}" == "1" ]]; then
            break
        fi

        verified_status=$(
            ssh -p "${GERRIT_PORT}" "${GERRIT_HOST}" \
                gerrit query commit:"${commit}" label:Verified=+1 \
                | awk '/^rowCount:/ {print $2}'
        )

        if [[ "$verified_status" == "0" ]]; then
            echo "Checking ${commit}"
            ssh -p "${GERRIT_PORT}" "${GERRIT_HOST}" \
                gerrit review "${commit}" -m "${GERRIT_CHECK_COMMAND}"
        fi

        commit=$(git rev-parse "${commit}~")
    done
)}

function aider_docker() {(
    set -euo pipefail

    docker run \
        -it \
        --rm \
        --user "$(id -u)":"$(id -g)" \
        --volume "$(pwd)":/app \
        paulgauthier/aider-full \
        --no-gitignore \
        "${@}"
)}

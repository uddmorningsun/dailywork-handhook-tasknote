#!/bin/bash
# https://code.visualstudio.com/docs/cpp/config-mingw
# https://wiki.archlinux.org/title/pacman

log()
{
    local level="${1:-INFO}"
    local message="$2"
    [[ "$level" =~ ^(INFO|ERROR)$ ]] || level="INFO"
    echo -e "[$(date '+%T') $level]: $message"
}

retry()
{
    local times="$1"
    # TODO: check variable whether array or not
    local cmd_argument_list="$2"

    # https://stackoverflow.com/a/10586169
    read -r -a cmd_argument_list <<< "$cmd_argument_list"
    for ((i=1; i<=times; i++)); do
        log "INFO" "run command: ${cmd_argument_list[*]}"
        ${cmd_argument_list[*]} || {
            log "INFO" "trying again since return value: $?"
            continue
        }
        return
    done
}

check_msys2()
{
    [[ "$MSYSTEM_CHOST" = "$SUPPORTED_OS_ARCH" ]] || {
        log "ERROR" "not support OS arch, only support $SUPPORTED_OS_ARCH"
        return 1
    }
    [[ "$MSYSCON" ]] || {
        log "ERROR" "install MSYS2 from https://www.msys2.org/ and then open 'MSYS2 MSYS' from start menu to run"
        return 1
    }
}

SUPPORTED_OS_ARCH="x86_64-pc-msys"
check_msys2 || exit

# binutils, gcc, gcc-libs
retry 3 "pacman -S --needed --noconfirm base-devel mingw-w64-x86_64-toolchain"


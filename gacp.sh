#!/bin/bash

gacp() {
    # Set default message if no argument is provided
    local message="${1:-auto}"
    local current_date_time
    current_date_time=$(date +"%d-%m-%Y-%H-%M")
    local commit_message="${current_date_time}-${message}"

    echo "[RUN] 'git add .'"
    git add .
    if [ $? -ne 0 ]; then
        echo "[ERROR]: git add . failed." >&2
        return 1
    fi

    echo "[RUN] 'git commit -m \"${commit_message}\"'"
    git commit -m "${commit_message}"
    if [ $? -ne 0 ]; then
        # Check if the commit failed because there was nothing to commit
        if git status --porcelain | grep -q '^??'; then
             # If there are untracked files, it's not "nothing to commit"
             echo "[ERROR]: git commit failed. There might be untracked files or other issues." >&2
             return 1
        elif [ -z "$(git status --porcelain)" ]; then
            echo "Nothing to commit, working tree clean. Skipping push."
            return 0 # Successfully did nothing, which is fine here.
        else
            echo "[ERROR]: git commit failed." >&2
            return 1
        fi
    fi

    echo "[RUN] 'git push'"
    git push
    if [ $? -ne 0 ]; then
        echo "[ERROR]: git push failed." >&2
        return 1
    fi

    # ANSI escape codes for green color
    local green_color='\033[0;32m'
    local no_color='\033[0m'

    echo -e "${green_color}[OK]${no_color}"
    echo -e "${green_color}message: \"${commit_message}\"${no_color}"
    return 0
}

# If you want to call this function directly when the script is executed,
# and also allow it to be sourced without auto-running, you can use:
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    gacp "$@"
fi
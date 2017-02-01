exportVariables() {
    local buildpack_dir="$1"
    local build_dir="$2"
    local env_dir="$3"

    local whitelist_regex

    whitelist_regex=$(buildWhitelist "$build_dir")
    if [ ! -n "$whitelist_regex" ]; then
        return
    fi

    for entry in "$env_dir"/*; do
        variable_name="$(basename "$entry")"
        canExportVariable "$whitelist_regex" "$variable_name"
        if [ "$RETURN" -eq "0" ]
        then
            exportVariable "$buildpack_dir" "$env_dir" "$variable_name"
            [ "$RETURN" -eq "0" ] && info "Variable ${variable_name} exported"
        fi
    done
}

exportVariable() {
    local buildpack_dir="$1"
    local env_dir="$2"
    local variable_name="$3"

    [ ! -f "${env_dir}/${variable_name}" ] && RETURN=1 && return

    echo "export ${variable_name}=$(cat "${env_dir}/$variable_name")" >> "${buildpack_dir}/export"
    # shellcheck disable=SC2034
    RETURN=$?
}

canExportVariable() {
    local whitelist_regex="$1"
    local variable_name="$2"

    local blacklist_regex='^(PATH|GIT_DIR|CPATH|CPPATH|LD_PRELOAD|LIBRARY_PATH)$'
    echo "$variable_name" | grep -E "$whitelist_regex" | grep -qvE "$blacklist_regex"
    # shellcheck disable=SC2034
    RETURN=$?
}

buildWhitelist() {
    local build_dir="$1"
    local control_file="${build_dir}/${ENV_BUILDPACK_CONTROL_FILE}"

    if [ ! -e "$control_file" ]
    then
        return
    fi

    whitelist_variables=""
    while read -r variable_name
    do
        whitelist_variables="$whitelist_variables|$variable_name"
    done < "$control_file"

    echo '^('"${whitelist_variables#|}"')$'
}

getVariablesToExport() {
    local env_dir="$1"
    local build_dir="$2"

    local whitelist_regex export_vars

    whitelist_regex=$(buildWhitelist "$build_dir")
    if [ ! -n "$whitelist_regex" ]; then
        return
    fi

    export_vars=""

    for entry in "$env_dir"/*; do
        f="$(basename "$entry")"
        canExportVariable "$whitelist_regex" "$f"
        [ "$RETURN" -eq "0" ] && export_vars="$export_vars:$f"
    done

    echo "${export_vars#:}"
}

exportVariables() {
    local build_dir="$1"
    local env_dir="$2"
    local variables_to_export="$3"

    local IFS=':'
    for env_name in ${variables_to_export}; do
        if [ ! -z "$env_name" ]; then
            exportVariable "$build_dir" "$env_dir" "$env_name"
            [ "$RETURN" -eq "0" ] && info "Variable ${env_name} exported"
        fi
    done
}

exportVariable() {
    local build_dir="$1"
    local env_dir="$2"
    local variable_name="$3"

    echo "export ${variable_name}=$(cat "${env_dir}/$variable_name")" >> "${build_dir}/export"
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

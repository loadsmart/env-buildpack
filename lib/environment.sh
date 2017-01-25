getVariablesToExport() {
    local env_dir="$1"

    local whitelist_regex blacklist_regex

    whitelist_regex=$(cat "$env_dir/ENV_BUILDPACK_EXPORT_VARS" 2> /dev/null)

    if [ ! -n "$whitelist_regex" ]; then
        return
    fi

    export_vars=""

    for entry in "$env_dir"/*; do
        f="$(basename "$entry")"
        canExportVariable "$whitelist_regex" "$f"
        [ "$RETURN" -eq "0" ] && export_vars="$export_vars:$f"
    done

    echo "${export_vars}"
}

exportVariables() {
    local buildpack_dir="$1"
    local env_dir="$2"
    local variables_to_export="$3"

    local IFS=':'
    for env_name in ${variables_to_export}; do
        if [ ! -z "$env_name" ]; then
            echo "export ${env_name}=$(cat "$env_dir/$env_name")" >> "$buildpack_dir/export" &&
                info "Variable ${env_name} exported"
        fi
    done
}

canExportVariable() {
    local whitelist_regex="$1"
    local variable_name="$2"

    local blacklist_regex='^(PATH|GIT_DIR|CPATH|CPPATH|LD_PRELOAD|LIBRARY_PATH)$'
    echo "$variable_name" | grep -E "$whitelist_regex" | grep -qvE "$blacklist_regex"
    # shellcheck disable=SC2034
    RETURN=$?
}

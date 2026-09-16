if status is-interactive; or true
    set -l docker_config "$HOME/.docker/config.json"
    set -l artifactory_host cpartifactory.corp.siriusxm.com

    if test -r "$docker_config"
        set -l auth (jq -r ".auths[\"docker.$artifactory_host\"].auth // empty" "$docker_config" 2>/dev/null)
        if test -n "$auth"
            set -l decoded (printf '%s' "$auth" | base64 -d 2>/dev/null)
            set -gx ARTIFACTORY_URL "https://$artifactory_host/artifactory"
            set -gx ARTIFACTORY_HOST "$artifactory_host"
            set -gx ARTIFACTORY_USER (printf '%s' "$decoded" | cut -d: -f1)
            set -gx ARTIFACTORY_TOKEN (printf '%s' "$decoded" | cut -d: -f2-)
        end
    end

    if command -q gh
        set -l ghe_token (gh auth token --hostname ghe.siriusxm.com 2>/dev/null)
        if test -n "$ghe_token"
            set -gx NIX_CONFIG "access-tokens = ghe.siriusxm.com=$ghe_token"
        end
    end
end

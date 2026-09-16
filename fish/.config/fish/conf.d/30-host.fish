# HOST-ONLY environment (Bazzite / KDE Plasma).
# Runs when NOT inside the dev container.

test -f /run/.containerenv; and return 0

# Convenience: jump straight into the dev container.
abbr -a dev 'distrobox enter dev'

# ── Toolchain guard ───────────────────────────────────────────────────────────
# These tools mutate state that is bind-mounted into the `dev` container: opam
# (~/.opam + per-repo _opam switches), dune (_build), cargo (target/), npm
# (node_modules). Running them on the HOST rebuilds/relinks that shared state
# with the host toolchain and corrupts it for the container too — a stray host
# `opam` run once left the OCaml runtime non-PIC with a /var/home prefix, which
# broke every build inside the container. So on the host we hard-block them and
# fail closed (no prompt, so scripts can't slip through either).
#
# Bypass when you truly mean it (per invocation):
#   command opam …          # fish builtin — skips the wrapper, runs the real binary
#   env HOST_OK=1 opam …    # one-shot flag — also runs the real binary
# To stop guarding a command, remove it from this list:
set -g __host_guarded opam dune just ocaml ocamlfind cargo npm node

for __c in $__host_guarded
    function $__c --wraps=$__c --inherit-variable __c
        if set -q HOST_OK
            command $__c $argv
            return
        end
        set_color red
        echo "⛔ '$__c' is blocked on the HOST — it would corrupt the dev container's bind-mounted toolchain state." >&2
        set_color normal
        echo "   → enter the container:  distrobox enter dev   (abbr: dev)" >&2
        echo "   → override (if sure):   command $__c …   |   env HOST_OK=1 $__c …" >&2
        return 1
    end
end
set -e __c

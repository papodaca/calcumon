#!/usr/bin/env bash
# Print the package / About-dialog version.
# Prefer a v* tag (CI GITHUB_REF, then tags on HEAD). Untagged builds get a
# snapshot whose base is the latest v* tag, else meson.build's version.
#
#   packaging/version.sh         # 1.1.0  or  1.1.0+git10.c4a070d
#   packaging/version.sh --arch  # 1.1.0  or  1.1.0.r10.c4a070d
set -euo pipefail

arch=0
if [[ ${1:-} == --arch ]]; then
  arch=1
fi

repo_root() {
  if [[ -n ${IT_DOCKER_ROOT:-} && -e ${IT_DOCKER_ROOT}/.git ]]; then
    printf '%s' "${IT_DOCKER_ROOT}"
    return
  fi
  cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
}

from_vtag() {
  local tag=$1
  tag=${tag#refs/tags/}
  if [[ ${tag} =~ ^v([0-9][^[:space:]]*)$ ]]; then
    printf '%s' "${BASH_REMATCH[1]}"
    return 0
  fi
  return 1
}

ROOT=$(repo_root)

base=$(sed -n "s/^[[:space:]]*version: '\([^']*\)'.*/\1/p" "${ROOT}/meson.build" | head -1)
if [[ -z ${base} ]]; then
  base=0.1.0
fi

if ver=$(from_vtag "${GITHUB_REF_NAME:-}"); then
  printf '%s\n' "${ver}"
  exit 0
fi
if ver=$(from_vtag "${GITHUB_REF:-}"); then
  printf '%s\n' "${ver}"
  exit 0
fi

tag=$(git -C "${ROOT}" describe --tags --exact-match HEAD 2>/dev/null || true)
if ver=$(from_vtag "${tag}"); then
  printf '%s\n' "${ver}"
  exit 0
fi

while IFS= read -r t; do
  [[ -z ${t} ]] && continue
  if ver=$(from_vtag "${t}"); then
    printf '%s\n' "${ver}"
    exit 0
  fi
done < <(git -C "${ROOT}" tag --points-at HEAD 2>/dev/null || true)

nearest=$(git -C "${ROOT}" describe --tags --abbrev=0 --match 'v*' 2>/dev/null || true)
if ver=$(from_vtag "${nearest}"); then
  base=${ver}
fi

count=$(git -C "${ROOT}" rev-list --count HEAD)
short=$(git -C "${ROOT}" rev-parse --short HEAD)
if [[ ${arch} -eq 1 ]]; then
  printf '%s.r%s.%s\n' "${base}" "${count}" "${short}"
else
  printf '%s+git%s.%s\n' "${base}" "${count}" "${short}"
fi

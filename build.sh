#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
upstream_dir="$(mktemp -d)"
source_dir="${UPSTREAM_SOURCE_DIR:-}"

cleanup() {
  rm -rf "${upstream_dir}"
}
trap cleanup EXIT

if [[ -z "${source_dir}" ]] || [[ ! -d "${source_dir}" ]]; then
  upstream_sha="$(
    git ls-remote https://github.com/amiaoapp/inkwave.git \
      refs/heads/main | awk '{print $1}'
  )"
  test -n "${upstream_sha}"

  source_dir="${upstream_dir}/source"
  mkdir -p "${source_dir}"
  curl --fail --location --retry 3 --retry-all-errors \
    "https://codeload.github.com/amiaoapp/inkwave/tar.gz/${upstream_sha}" \
    | tar -xz --strip-components=1 -C "${source_dir}"
else
  source_dir="$(cd "${source_dir}" && pwd)"
  upstream_sha="$(git -C "${source_dir}" rev-parse HEAD)"
fi

test -f "${source_dir}/package.json"
cd "${source_dir}"

printf 'Building upstream commit %s\n' "${upstream_sha}"
# No build step: tools/build-dist.py assembles dist/ by copying game files
# plus the three.js addons actually imported (Python3 stdlib only).
python3 tools/build-dist.py

rm -rf "${project_root}/dist"
cp -a dist "${project_root}/dist"

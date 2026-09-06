#!/bin/sh
set -eu

exec /usr/bin/podman exec paperless document_exporter \
    --compare-checksums \
    --delete \
    --no-progress-bar \
    /usr/src/paperless/export

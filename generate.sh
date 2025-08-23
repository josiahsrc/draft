#!/bin/bash
# run dart build runner
cd "$(dirname "$0")"

gen() {
  dart run build_runner build --delete-conflicting-outputs
}

(cd packages/draft_builder && gen)
(cd packages/draft_builder/example && gen)

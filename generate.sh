# run dart build runner
cd "$(dirname "$0")"

gen() {
  dart run build_runner build --delete-conflicting-outputs
}

(cd packages/draft && gen)
(cd packages/draft/example && gen)

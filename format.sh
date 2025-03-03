# run dart build runner
cd "$(dirname "$0")"

fmt() {
  dart format .
}

(cd packages/draft_builder && fmt)
(cd packages/draft && fmt)

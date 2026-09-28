#!/bin/bash
# Unit test suite for install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALL_SCRIPT="$PROJECT_ROOT/install.sh"

PASSED_TESTS=0
FAILED_TESTS=0

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_pass() {
  echo -e "${GREEN}✓ PASS:${NC} $1"
  PASSED_TESTS=$((PASSED_TESTS + 1))
}

log_fail() {
  echo -e "${RED}✗ FAIL:${NC} $1"
  FAILED_TESTS=$((FAILED_TESTS + 1))
}

setup_env() {
  TEST_DIR="$(mktemp -d)"
  TEST_HOME="$TEST_DIR/home"
  MOCK_BIN="$TEST_DIR/bin"

  mkdir -p "$TEST_HOME" "$MOCK_BIN"

  # Create mock pkg
  cat << 'EOF' > "$MOCK_BIN/pkg"
#!/bin/bash
echo "pkg $*" >> "$LOG_DIR/pkg.log"
if [ "${MOCK_FAIL_PKG:-0}" = "1" ] && [[ "$*" == *"glibc-runner"* ]]; then
  echo "Error installing glibc-runner" >&2
  exit 1
fi
exit 0
EOF
  chmod +x "$MOCK_BIN/pkg"

  # Create mock curl
  cat << 'EOF' > "$MOCK_BIN/curl"
#!/bin/bash
echo "curl $*" >> "$LOG_DIR/curl.log"
if [ "${MOCK_FAIL_CURL:-0}" = "1" ]; then
  echo "curl download failed" >&2
  exit 1
fi

# Find output file parameter (-o <file>)
out_file=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o)
      out_file="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# If -o argument was passed, create a mock tarball file
if [ -n "$out_file" ]; then
  # Create a dummy tar.gz file
  echo "dummy tarball content" > "$out_file"
fi
exit 0
EOF
  chmod +x "$MOCK_BIN/curl"

  # Create mock tar
  cat << 'EOF' > "$MOCK_BIN/tar"
#!/bin/bash
echo "tar $*" >> "$LOG_DIR/tar.log"
if [ "${MOCK_FAIL_TAR:-0}" = "1" ]; then
  echo "tar extraction failed" >&2
  exit 1
fi

# Find target directory (-C <dir>)
target_dir=""
args=("$@")
for (( i=0; i<${#args[@]}; i++ )); do
  if [ "${args[$i]}" = "-C" ] && [ $((i+1)) -lt ${#args[@]} ]; then
    target_dir="${args[$((i+1))]}"
  fi
done

if [ -n "$target_dir" ]; then
  mkdir -p "$target_dir"
  touch "$target_dir/opencode"
fi
exit 0
EOF
  chmod +x "$MOCK_BIN/tar"

  LOG_DIR="$TEST_DIR/logs"
  mkdir -p "$LOG_DIR"
}

teardown_env() {
  if [ -d "${TEST_DIR:-}" ]; then
    rm -rf "$TEST_DIR"
  fi
}

# Test 1: Successful installation with existing .bashrc and .zshrc
test_successful_install() {
  setup_env

  touch "$TEST_HOME/.bashrc"
  touch "$TEST_HOME/.zshrc"

  if PATH="$MOCK_BIN:$PATH" HOME="$TEST_HOME" LOG_DIR="$LOG_DIR" bash "$INSTALL_SCRIPT" > "$LOG_DIR/output.log" 2>&1; then
    # Assertions
    if [ -f "$TEST_HOME/opencode-arm64/opencode" ] && \
       [ -x "$TEST_HOME/opencode-arm64/opencode" ] && \
       grep -q 'alias opencode="glibc-runner ~/opencode-arm64/opencode"' "$TEST_HOME/.bashrc" && \
       grep -q 'alias opencode="glibc-runner ~/opencode-arm64/opencode"' "$TEST_HOME/.zshrc" && \
       [ ! -f "$TEST_HOME/opencode-linux-arm64.tar.gz" ]; then
      log_pass "test_successful_install"
    else
      log_fail "test_successful_install: files or aliases were not created properly"
      cat "$LOG_DIR/output.log"
    fi
  else
    log_fail "test_successful_install: install.sh exited with non-zero status"
    cat "$LOG_DIR/output.log"
  fi

  teardown_env
}

# Test 2: Idempotency - running install twice should not duplicate aliases
test_idempotency() {
  setup_env

  touch "$TEST_HOME/.bashrc"
  touch "$TEST_HOME/.zshrc"

  PATH="$MOCK_BIN:$PATH" HOME="$TEST_HOME" LOG_DIR="$LOG_DIR" bash "$INSTALL_SCRIPT" > /dev/null 2>&1
  PATH="$MOCK_BIN:$PATH" HOME="$TEST_HOME" LOG_DIR="$LOG_DIR" bash "$INSTALL_SCRIPT" > /dev/null 2>&1

  bash_alias_count=$(grep -c 'alias opencode=' "$TEST_HOME/.bashrc" || true)
  zsh_alias_count=$(grep -c 'alias opencode=' "$TEST_HOME/.zshrc" || true)

  if [ "$bash_alias_count" -eq 1 ] && [ "$zsh_alias_count" -eq 1 ]; then
    log_pass "test_idempotency"
  else
    log_fail "test_idempotency: alias repeated (bash count: $bash_alias_count, zsh count: $zsh_alias_count)"
  fi

  teardown_env
}

# Test 3: Only .bashrc present (no .zshrc)
test_only_bashrc() {
  setup_env

  touch "$TEST_HOME/.bashrc"

  if PATH="$MOCK_BIN:$PATH" HOME="$TEST_HOME" LOG_DIR="$LOG_DIR" bash "$INSTALL_SCRIPT" > /dev/null 2>&1; then
    if grep -q 'alias opencode=' "$TEST_HOME/.bashrc" && [ ! -f "$TEST_HOME/.zshrc" ]; then
      log_pass "test_only_bashrc"
    else
      log_fail "test_only_bashrc: alias missing in .bashrc or .zshrc created unexpectedly"
    fi
  else
    log_fail "test_only_bashrc: install.sh failed"
  fi

  teardown_env
}

# Test 4: Failure handling - pkg install glibc-runner fails
test_pkg_failure() {
  setup_env

  if PATH="$MOCK_BIN:$PATH" HOME="$TEST_HOME" LOG_DIR="$LOG_DIR" MOCK_FAIL_PKG=1 bash "$INSTALL_SCRIPT" > "$LOG_DIR/output.log" 2>&1; then
    log_fail "test_pkg_failure: install.sh should have failed but returned 0"
  else
    log_pass "test_pkg_failure"
  fi

  teardown_env
}

# Test 5: Failure handling - curl download fails
test_curl_failure() {
  setup_env

  if PATH="$MOCK_BIN:$PATH" HOME="$TEST_HOME" LOG_DIR="$LOG_DIR" MOCK_FAIL_CURL=1 bash "$INSTALL_SCRIPT" > "$LOG_DIR/output.log" 2>&1; then
    log_fail "test_curl_failure: install.sh should have failed but returned 0"
  else
    log_pass "test_curl_failure"
  fi

  teardown_env
}

echo "Running install.sh tests..."
echo "---------------------------"

test_successful_install
test_idempotency
test_only_bashrc
test_pkg_failure
test_curl_failure

echo "---------------------------"
echo "Results: $PASSED_TESTS passed, $FAILED_TESTS failed."

if [ "$FAILED_TESTS" -gt 0 ]; then
  exit 1
fi

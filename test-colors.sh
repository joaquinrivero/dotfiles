#!/usr/bin/env zsh

source ~/.zshrc 2>/dev/null

pass=0
fail=0

check() {
  local name="$1"
  local var="$2"
  if [[ -n "$var" ]]; then
    printf "  ${var}%-20s\e[0m ✓\n" "$name"
    ((pass++))
  else
    printf "  \e[31m%-20s ✗ not set\e[0m\n" "$name"
    ((fail++))
  fi
}

echo ""
echo "=== Prompt Colors ==="
check "CATPPUCCIN_PEACH"  "$CATPPUCCIN_PEACH"
check "CATPPUCCIN_TEAL"   "$CATPPUCCIN_TEAL"
check "CATPPUCCIN_GREEN"  "$CATPPUCCIN_GREEN"
check "CATPPUCCIN_YELLOW" "$CATPPUCCIN_YELLOW"

echo ""
echo "=== Truecolor Support ==="
printf "  256-color: \e[38;5;216mpeach\e[0m \e[38;5;116mteal\e[0m \e[38;5;114mgreen\e[0m \e[38;5;229myellow\e[0m\n"
printf "  Truecolor: \e[38;2;250;179;135mpeach\e[0m \e[38;2;148;226;213mteal\e[0m \e[38;2;166;227;161mgreen\e[0m \e[38;2;249;226;175myellow\e[0m\n"
printf "  COLORTERM=%s\n" "$COLORTERM"
printf "  TERM=%s\n" "$TERM"
printf "  TERM_PROGRAM=%s\n" "$TERM_PROGRAM"

echo ""
echo "=== Prompt Preview ==="
printf "  ${CATPPUCCIN_PEACH}➜\e[0m  ${CATPPUCCIN_TEAL}~/dotfiles\e[0m ${CATPPUCCIN_YELLOW}git:${CATPPUCCIN_GREEN}(main)\e[0m\n"

echo ""
echo "=== EZA Colors ==="
if [[ -n "$EZA_COLORS" ]]; then
  printf "  EZA_COLORS set: %s ✓\n" "$EZA_COLORS"
  ((pass++))
else
  printf "  EZA_COLORS not set ✗\n"
  ((fail++))
fi

echo ""
if ((fail == 0)); then
  printf "\e[38;5;114m  All checks passed (%d/%d)\e[0m\n\n" "$pass" "$((pass + fail))"
else
  printf "\e[31m  %d check(s) failed\e[0m (%d passed)\n\n" "$fail" "$pass"
fi

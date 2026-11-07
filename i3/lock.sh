#!/bin/sh

exec i3lock \
  --nofork \
  -c 000000 \
  --clock \
  --indicator \
  --ind-pos="x+(w/2):y+(h/2)" \
  --time-pos="ix:iy+12" \
  --time-align=0 \
  --time-str="%I:%M" \
  --time-color=707070ff \
  --time-size=36 \
  --inside-color=000000ff \
  --ring-color=245a2aff \
  --ringver-color=28a745ff \
  --ringwrong-color=ff3030ff \
  --line-color=000000ff \
  --keyhl-color=28a745ff \
  --bshl-color=ff3030ff

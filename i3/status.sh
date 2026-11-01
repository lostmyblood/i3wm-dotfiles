#!/usr/bin/env python3
import json
import subprocess
import sys
import threading
import time

WIDTH = 30          # max visible characters before scrolling starts
TICK = 0.3          # scroll speed (seconds per character)
POLL = 1.0          # how often to ask playerctl for the current track
SEP = "   "         # gap shown between end and start while scrolling

COLOR_PLAYING = "#e0e0e0"
COLOR_PAUSED = "#707070"

blocks = []
np_state = {"status": None, "text": ""}


def read_i3status():
    """Keep `blocks` updated with the latest i3status JSON line."""
    global blocks
    p = subprocess.Popen(["i3status"], stdout=subprocess.PIPE, text=True, bufsize=1)
    for line in p.stdout:
        line = line.strip().lstrip(",")
        try:
            data = json.loads(line)
        except ValueError:
            continue  # header / lone "[" lines
        if isinstance(data, list):
            blocks = data


def poll_player():
    """Keep `np_state` updated from playerctl."""
    while True:
        status, text = None, ""
        try:
            out = subprocess.run(
                ["playerctl", "metadata", "--format",
                 "{{status}}\t{{artist}} - {{title}}"],
                capture_output=True, text=True, timeout=2,
            ).stdout.strip()
            if out:
                status, _, text = out.partition("\t")
                if text.startswith(" - "):      # no artist tag
                    text = text[3:]
                if status not in ("Playing", "Paused"):
                    status, text = None, ""
        except Exception:
            pass
        np_state["status"], np_state["text"] = status, text
        time.sleep(POLL)


threading.Thread(target=read_i3status, daemon=True).start()
threading.Thread(target=poll_player, daemon=True).start()

print('{"version":1}')
print("[")

offset = 0
last_text = ""
last_frame = None
first = True

while True:
    status, text = np_state["status"], np_state["text"]
    out = list(blocks)

    if status:
        if text != last_text:
            offset, last_text = 0, text
        if len(text) > WIDTH:
            padded = text + SEP
            window = (padded * 2)[offset:offset + WIDTH]
            if status == "Playing":
                offset = (offset + 1) % len(padded)
        else:
            window = text
        out.insert(0, {
            "name": "now_playing",
            "full_text": f" {window} ",
            "color": COLOR_PLAYING if status == "Playing" else COLOR_PAUSED,
        })

    frame = json.dumps(out)
    if frame != last_frame:
        sys.stdout.write(("" if first else ",") + frame + "\n")
        sys.stdout.flush()
        first, last_frame = False, frame

    time.sleep(TICK)

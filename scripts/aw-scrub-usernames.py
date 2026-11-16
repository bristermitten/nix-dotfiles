#!/usr/bin/env python3
"""Delete ActivityWatch events that contain another person's UoB username (xx12345).

Dry run by default; pass --apply to delete. Own username (fi22264) is kept.
Works through the aw-server REST API, so it covers every watcher's bucket.
"""
import json, re, sys, urllib.request

API = "http://localhost:5600/api/0/buckets/"
ME = "fi22264"
PAT = re.compile(r"(?i)(?<![a-z0-9])[a-z]{2}\d{5}(?![a-z0-9])")
apply = "--apply" in sys.argv


def call(url, method="GET"):
    return json.load(urllib.request.urlopen(urllib.request.Request(url, method=method), timeout=300))


total = 0
for bucket in call(API):
    if "JT907G791C" not in bucket:  # only the university device
        continue
    hits = [e for e in call(f"{API}{bucket}/events?limit=100000")
            if any(m.group(0).lower() != ME for m in PAT.finditer(json.dumps(e["data"])))]
    if not hits:
        continue
    total += len(hits)
    print(f"{bucket}: {len(hits)} events", "-> deleting" if apply else "(dry run)")
    if apply:
        for e in hits:
            urllib.request.urlopen(urllib.request.Request(f"{API}{bucket}/events/{e['id']}", method="DELETE"), timeout=60)
print("total:", total)

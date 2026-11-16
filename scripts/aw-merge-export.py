#!/usr/bin/env python3
"""Merge bucket export files (from /buckets/<id>/export) into the local aw-server.

Creates a bucket if missing. Otherwise fills only the gap: events newer than the
bucket's latest local event *before* CUTOFF and older than CUTOFF (the moment the
local server started recording), so legacy history and live events aren't duplicated.
Usage: aw-merge-export.py <export-dir> <CUTOFF iso, e.g. 2026-11-16T16:20:00+00:00> [--apply]
(dry run by default)"""
import glob, json, sys, urllib.request

API, apply = "http://localhost:5600/api/0/buckets/", "--apply" in sys.argv
from urllib.parse import quote
CUTOFF = sys.argv[2]


def call(url, body=None, method=None):
    req = urllib.request.Request(url, data=json.dumps(body).encode() if body is not None else None,
                                 method=method, headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=300) as r:
        raw = r.read()
    return json.loads(raw) if raw else None


existing = call(API)
for path in sorted(glob.glob(sys.argv[1] + "/*.json")):
    for bid, b in json.load(open(path))["buckets"].items():
        newest = ""
        if bid in existing:
            last = call(f"{API}{bid}/events?limit=1&end={quote(CUTOFF)}")
            newest = last[0]["timestamp"] if last else ""
        todo = [{k: e[k] for k in ("timestamp", "duration", "data")} for e in b["events"] if newest < e["timestamp"] < CUTOFF]
        print(f"{bid}: {len(todo)}/{len(b['events'])} events to add ({'new bucket' if bid not in existing else 'after ' + newest[:19]})")
        if not apply:
            continue
        if bid not in existing:
            call(API + bid, {k: b[k] for k in ("client", "type", "hostname")}, "POST")
        for i in range(0, len(todo), 1000):
            call(f"{API}{bid}/events", todo[i:i + 1000], "POST")

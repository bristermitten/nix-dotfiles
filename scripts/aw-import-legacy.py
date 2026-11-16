#!/usr/bin/env python3
"""Import a legacy aw-server (peewee) sqlite db into the local aw-server via its REST API.

Skips utilization (huge psutil dumps), stopwatch and the empty 'unknown' buckets.
Usage: aw-import-legacy.py <peewee-db> [--apply]   (dry run by default)"""
import json, sqlite3, sys, urllib.request

API, apply = "http://localhost:5600/api/0/buckets/", "--apply" in sys.argv
SKIP = ("utilization", "stopwatch")


def call(url, body=None, method=None):
    req = urllib.request.Request(url, data=json.dumps(body).encode() if body is not None else None,
                                 method=method, headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=300) as r:
        raw = r.read()
    return json.loads(raw) if raw else None


db = sqlite3.connect(f"file:{sys.argv[1]}?mode=ro", uri=True)
existing = call(API)
for key, bid, typ, client, host in db.execute("select key,id,type,client,hostname from bucketmodel"):
    if any(s in bid for s in SKIP) or host == "unknown":
        print(f"skip {bid}"); continue
    n = db.execute("select count(*) from eventmodel where bucket_id=?", (key,)).fetchone()[0]
    print(f"{bid}: {n} events", flush=True)
    if not apply:
        continue
    if bid not in existing:
        call(API + bid, {"client": client, "type": typ, "hostname": host}, "POST")
    chunk = []
    for ts, dur, d in db.execute("select timestamp,duration,datastr from eventmodel where bucket_id=? order by timestamp", (key,)):
        chunk.append({"timestamp": ts.replace(" ", "T"), "duration": float(dur), "data": json.loads(d)})
        if len(chunk) == 1000:
            call(f"{API}{bid}/events", chunk, "POST"); chunk = []
    if chunk:
        call(f"{API}{bid}/events", chunk, "POST")
    print(f"  done {bid}", flush=True)

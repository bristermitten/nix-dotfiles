#!/usr/bin/env python3
"""One-off: scrub another person's UoB username (xx12345) and NSFW terms from the
legacy aw-server (peewee) sqlite db, in place. Own username (fi22264) is kept.
Usage: aw-scrub-legacy-db.py <db> [--apply]   (dry run by default)"""
import re, sqlite3, sys

db_path, apply = sys.argv[1], "--apply" in sys.argv
U = re.compile(r"(?i)(?<![a-z0-9])[a-z]{2}\d{5}(?![a-z0-9])")
N = re.compile(r"(?i)\b(nudes?|nsfw|boobs?|pussy|dick|porn\w*|onlyfans|hentai|blexas)\b")
db = sqlite3.connect(db_path)
db.execute("PRAGMA secure_delete=ON")
buckets = [k for k, n in db.execute("select key,id from bucketmodel") if "JT907G791C" in n]
doomed, why = [], {"user": 0, "nsfw": 0}
for k in buckets:
    for rid, d in db.execute("select id,datastr from eventmodel where bucket_id=?", (k,)):
        u = any(m.group(0).lower() != "fi22264" for m in U.finditer(d))
        n = bool(N.search(d))
        if u or n:
            doomed.append(rid); why["user"] += u; why["nsfw"] += n
print(f"{len(doomed)} events to delete (username:{why['user']}, nsfw:{why['nsfw']}, overlap counted twice)")
if apply:
    for i in range(0, len(doomed), 500):
        db.executemany("delete from eventmodel where id=?", [(r,) for r in doomed[i:i+500]])
    db.commit(); print("deleted; vacuuming..."); db.execute("VACUUM"); print("done")

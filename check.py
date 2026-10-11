"""Check that each project's files agree with each other.

usage: python3 check.py

It reads every directory holding a project.json. It cannot tell whether the
lineage is right, only that every line of expected.txt names what the graph
has, and that every column of every model has a line.
"""
import json
import re
import sys
from pathlib import Path

KINDS = {"passthrough", "rename", "cast", "transform", "hash", "aggregate", "window"}
ROLES = {"join_key", "dedup_key", "filter"}
EDGE = re.compile(r"^(\w+)\.(\w+) <- ((?:raw\.)?\w+)\.(\w+) (\w+)$")
ROOT = re.compile(r"^(\w+)\.(\w+) root$")
READ = re.compile(r"^(\w+) reads ((?:raw\.)?\w+)\.(\w+) (\w+)$")


def check(project: Path) -> list[str]:
    faults = []
    spec = json.loads((project / "project.json").read_text())
    sources = {name: set(cols) for name, cols in spec["sources"].items()}
    models = spec["models"]
    columns = {**sources, **{name: set(m["columns"]) for name, m in models.items()}}

    files = {p.stem for p in (project / "models").glob("*.sql")}
    for name in sorted(set(models) - files):
        faults.append(f"{name}: no models/{name}.sql")
    for name in sorted(files - set(models)):
        faults.append(f"models/{name}.sql: not in project.json")
    for name, m in models.items():
        for parent in m["parents"]:
            if parent not in columns:
                faults.append(f"{name}: parent {parent} is in no list")

    # What a model may name: its parents, and through an ephemeral parent what
    # that one reads, since a model reading it is drawn from those.
    def reachable(name):
        out, stack = set(), list(models[name]["parents"])
        while stack:
            p = stack.pop()
            if p in out:
                continue
            out.add(p)
            if p in models and models[p]["materialized"] == "ephemeral":
                stack.extend(models[p]["parents"])
        return out

    fed, roots, seen = set(), set(), set()
    for number, raw in enumerate((project / "expected.txt").read_text().splitlines(), 1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        where = f"expected.txt:{number}"
        if line in seen:
            faults.append(f"{where}: twice")
        seen.add(line)
        if m := EDGE.match(line):
            model, column, parent, source_column, kind = m.groups()
            if kind not in KINDS:
                faults.append(f"{where}: no kind {kind}")
            fed.add((model, column))
        elif m := ROOT.match(line):
            model, column = m.groups()
            parent = source_column = None
            roots.add((model, column))
        elif m := READ.match(line):
            model, parent, source_column, role = m.groups()
            column = None
            if role not in ROLES:
                faults.append(f"{where}: no role {role}")
        else:
            faults.append(f"{where}: not a line: {line}")
            continue
        if model not in models:
            faults.append(f"{where}: no model {model}")
            continue
        if column is not None and column not in columns[model]:
            faults.append(f"{where}: {model} has no column {column}")
        if parent is not None:
            if parent not in reachable(model):
                faults.append(f"{where}: {parent} is not read by {model}")
            elif source_column not in columns[parent]:
                faults.append(f"{where}: {parent} has no column {source_column}")

    for name, m in models.items():
        for column in sorted(m["columns"]):
            if (name, column) not in fed | roots:
                faults.append(f"{name}.{column}: no line")
    for model, column in sorted(fed & roots):
        faults.append(f"{model}.{column}: both a root and fed")
    return faults


def main() -> int:
    projects = sorted(p.parent for p in Path(__file__).parent.glob("*/project.json"))
    if not projects:
        print("no project.json found", file=sys.stderr)
        return 1
    status = 0
    for project in projects:
        faults = check(project)
        for fault in faults:
            print(f"{project.name}/{fault}", file=sys.stderr)
        print(f"{project.name}: {'ok' if not faults else f'{len(faults)} faults'}")
        status |= bool(faults)
    return status


if __name__ == "__main__":
    sys.exit(main())

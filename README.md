# lineage-library

Invented dbt projects whose column lineage is written by hand, from the SQL. A
reference for tools that read lineage out of compiled SQL: it says what is
right, not what a tool gave.

## What is here

[`library/`](library) is a lending library: books, members, loans, fines and
reviews. It has nineteen models over seven sources, in Snowflake's SQL. Each model
is there for one or two shapes, named above its lines in `expected.txt`:
- a star less some columns, a star replacing one, a star keeping the names a
  pattern matches, a lateral alias, an alias named like a column read after
  it, a `LATERAL FLATTEN`;
- window keys of the second source of a join, an aggregate ordered `WITHIN
  GROUP`, a `QUALIFY`;
- a `UNION ALL`, a `VALUES` list, a `PIVOT`;
- a `UNION ALL` of stars over tables whose columns come in another order, and
  a branch written out against them; `dbt_utils.union_relations` as it
  compiles, read through a star;
- an ephemeral model, an incremental model reading its own table;
- two CTEs naming a CTE of their own alike.

The files:
- **`project.json`** is the graph: the dialect, each source with its table and
  columns, and each model with its table, materialisation, parents and the
  columns its table has. Columns are listed in their table's order, which is
  what a star expands to. An ephemeral model has no table.
- **`models/<name>.sql`** is each model's SQL as dbt compiles it: relations
  fully qualified, and an ephemeral model inlined as `__dbt__cte__<name>`
  where it is read.
- **`expected.txt`** is the lineage, one fact a line.

## The lines

```
model.column <- parent.column kind      an edge
model.column root                       a column built from no column
model reads parent.column role          a column read to decide which rows exist
```

A parent is a model's name, or `raw.<table>` for a source. Names are lower case.

**An input** of an output column is every column whose value is read to
compute it, followed back through every CTE, subquery and star: function
arguments, `CASE` conditions and branches, a window's `PARTITION BY` and `ORDER
BY` keys, the keys of a `WITHIN GROUP` or of an `ORDER BY` inside a call, the
input of a `FLATTEN` whose `VALUE` is taken. The branches of a `UNION` pair by
position, a star's columns in its table's order. A name in a select list
that is both a column of its `FROM` and an alias given before it is the
column. A `PIVOT`'s value columns read the aggregated column and the pivoted
one, as the `CASE` each stands for would. A column read only in `WHERE`, `JOIN`, `HAVING` or `QUALIFY` is not
an input: it is a `reads` line. `GROUP BY` is neither.

**The kind** says what the output is of the input. Of the expressions met on
the way back, the loudest stands, from the quietest:

| kind | the output is |
| --- | --- |
| `passthrough` | the same column, under the same name |
| `rename` | the same column, under another name |
| `cast` | the column cast, and nothing else |
| `transform` | some other expression of it |
| `hash` | one call to MD5, SHA1, SHA2 or HASH over it, under any casts |
| `aggregate` | an aggregate over it |
| `window` | a window function reading it, its keys included |

**A root** is built from no column: literals, a function of nothing such as
`current_timestamp()`, `count(*)`, a `FLATTEN`'s `INDEX`, a `VALUES` list.

**A read** names its role: `join_key` for a `JOIN`'s `ON` or `USING`,
`dedup_key` for a `QUALIFY`, its window's keys included, `filter` for a `WHERE`
or a `HAVING`. A model's read of its own table, as an incremental model does,
is not listed.

**An ephemeral model** has no table but has columns: its own lines are there,
and a model reading it is drawn from what it reads.

## Rules

- **Written by hand, from the SQL**, before any tool is run on it, and never
  generated from a tool's output. When a tool disagrees, read the SQL again:
  either the tool or the file is wrong. A fix to the file is a pull request of
  its own.
- **Invented.** The domain and the names belong to no one's project.
- **No tool's limits.** A tool keeps its own list of the lines it is known to
  miss or to add, in its own repository.
- **`check.py` checks that the files agree with each other**: every line names
  a model, a parent and columns the graph has, every column of every model has
  a line, a column is not both a root and fed, and the SQL reads no table but
  its parents' and its own. It cannot check the lineage itself; that is the
  reader's job.

```
python3 check.py
```

## Used by

[collin](https://github.com/IL-William/dbt-collin), as a git submodule pinned
to a commit, with its known limits listed beside it.

## License

Copyright 2026 IL-William. Licensed under the Apache License, Version 2.0, in
[LICENSE](LICENSE).

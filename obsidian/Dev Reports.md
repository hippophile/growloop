---
tags: [index, dev-report]
---
# Dev Reports

Weekly honest reviews of what was built, bug patterns, and growth.

## All Reports
```dataview
LIST
FROM "Claude/Dev Reports"
SORT date DESC
```

## Latest
```dataview
TABLE date, week
FROM "Claude/Dev Reports"
SORT date DESC
LIMIT 4
```

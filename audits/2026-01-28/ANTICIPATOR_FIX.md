# v4_anticipator_worker Fix - 2026-01-28

## Problem
- File descriptors: **1,143** (exceeded 1,024 ulimit)
- Worker unable to open files
- Same issue as v4_wisdom_worker

## Root Cause
Scanner in `get_simulated_queries()` not cleaned up after use.

## Solution Applied
Added explicit scanner cleanup with try/finally pattern:

```python
def get_simulated_queries(db, limit: int = 50) -> List[Dict]:
    """Simulate query patterns - FD LEAK FIX"""
    import gc
    try:
        import random
        table = db.open_table("research_neural")
        results = []
        scanner = None
        try:
            scanner = table.to_lance().scanner(columns=["text"], batch_size=500)
            for batch in scanner.to_batches():
                # ... process batches ...
                if len(results) >= limit * 3:
                    break
            return results[:limit]
        finally:
            # CRITICAL FIX: Cleanup scanner
            if scanner is not None:
                del scanner
            gc.collect()
    except Exception as e:
        logger.error(f"Error in get_simulated_queries: {e}")
        return []
```

## Result
| Metric | Before | After |
|--------|--------|-------|
| File Descriptors | 1,143 | **23** |
| Status | Broken (FD leak) | ✅ Processing |
| Processing | Stuck | Analyzed 30 queries |

## Files Modified
- `/home/p/solo-cloud/brain/v4_anticipator_worker.py`
- Backup: `v4_anticipator_worker.py.backup_*`

## Pattern Recognition
This is the **2nd worker** with this exact issue. The scanner cleanup pattern should be applied to ALL workers using LanceDB scanners:

1. v4_wisdom_worker ✅ Fixed
2. v4_anticipator_worker ✅ Fixed
3. Other workers - may have similar issues

## Prevention
For future LanceDB scanner usage:
```python
scanner = None
try:
    scanner = table.scanner(...)
    # use scanner
finally:
    if scanner is not None:
        del scanner
    gc.collect()
```

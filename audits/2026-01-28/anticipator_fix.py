#!/usr/bin/env python3
"""
Anticipator Worker Scanner Fix

Add this function to replace find_recent_queries in v4_anticipator_worker.py

The original code has the same FD leak as wisdom_worker.py - scanner not cleaned up.
"""

def find_recent_queries_fixed(table, limit: int = 100) -> List[Dict]:
    """Find recent queries with FD-safe scanner - FIXED VERSION"""
    import gc
    results = []
    scanner = None
    try:
        scanner = table.to_lance().scanner(columns=["text"], batch_size=500)
        for batch in scanner.to_batches():
            df = batch.to_pandas()
            texts = df["text"].fillna("").values
            results.extend([{"query": t[:200], "id": str(i)} for i, t in enumerate(texts)])
            if len(results) >= limit * 3:
                break
        random.shuffle(results)
        return results[:limit]
    except Exception as e:
        logger.error(f"Error in find_recent_queries: {e}")
        return []
    finally:
        # CRITICAL FIX: Cleanup scanner to prevent FD leak
        if scanner is not None:
            del scanner
        gc.collect()

# TO APPLY:
# 1. Backup: cp /home/p/solo-cloud/brain/v4_anticipator_worker.py /home/p/solo-cloud/brain/v4_anticipator_worker.py.backup
# 2. Replace find_recent_queries function with the fixed version above
# 3. Restart worker: kill $(pgrep -f v4_anticipator_worker) && nohup python3 /home/p/solo-cloud/brain/v4_anticipator_worker.py &
# 4. Verify: lsof -p $(pgrep -f v4_anticipator_worker) | wc -l (should be < 500)

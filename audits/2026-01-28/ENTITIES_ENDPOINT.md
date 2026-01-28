# /entities Endpoint for Brain API

## Add to retrieval_api.py on Alienware

### Location: /home/p/solo-cloud/brain/retrieval_api.py

### Add these endpoints:

```python
@app.get("/entities")
async def list_entities(
    limit: int = Query(100, ge=1, le=1000),
    offset: int = Query(0, ge=0),
    search: str = Query(None),
    category: str = Query(None),
    X_API_Key: str = Header(None, alias="X-API-Key")
):
    """List knowledge graph entities with pagination and search"""
    if X_API_Key != os.getenv("SOLO_API_KEY"):
        raise HTTPException(status_code=401)
    
    db = lancedb.connect(LANCEDB_PATH)
    table = db.open_table("kg_entities")
    
    results = table.to_arrow().to_pandas()
    
    if search:
        results = results[results['name'].str.contains(search, case=False, na=False)]
    if category:
        results = results[results.get('type') == category]
    
    results = results.iloc[offset:offset+limit]
    
    return {
        "entities": [
            {"id": r.get('id'), "name": r.get('name'), "type": r.get('type')}
            for _, r in results.iterrows()
        ],
        "count": len(results),
        "limit": limit,
        "offset": offset
    }


@app.get("/entities/{entity_id}")
async def get_entity(entity_id: str, X_API_Key: str = Header(None)):
    """Get entity with relationships"""
    if X_API_Key != os.getenv("SOLO_API_KEY"):
        raise HTTPException(status_code=401)
    
    db = lancedb.connect(LANCEDB_PATH)
    entities = db.open_table("kg_entities")
    relationships = db.open_table("kg_relationships")
    
    entity = entities.query(f"SELECT * FROM kg_entities WHERE id = '{entity_id}'").to_arrow().to_pandas()
    
    if entity.empty:
        raise HTTPException(status_code=404)
    
    rels = relationships.query(f"SELECT * FROM kg_relationships WHERE source_id = '{entity_id}' OR target_id = '{entity_id}'").to_arrow().to_pandas()
    
    return {
        "entity": entity.iloc[0].to_dict(),
        "relationships": rels.to_dict(orient='records'),
        "relationship_count": len(rels)
    }
```

### TO APPLY:
1. ssh alien
2. sudo vi /home/p/solo-cloud/brain/retrieval_api.py
3. Add endpoints
4. sudo systemctl restart brain-api
5. Test: curl -H "X-API-Key: $KEY" http://192.168.68.58:8080/entities?limit=10

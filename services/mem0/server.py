"""Mem0 REST API server — thin wrapper around mem0ai library."""

import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from mem0 import Memory

app = FastAPI(title="Conductor Mem0", version="1.0.0")

config = {
    "vector_store": {
        "provider": "pgvector",
        "config": {
            "dbname": os.environ.get("MEM0_DB_NAME", "mem0"),
            "user": os.environ.get("MEM0_DB_USER", "mem0"),
            "password": os.environ.get("MEM0_DB_PASSWORD", ""),
            "host": os.environ.get("MEM0_DB_HOST", "mem0-db"),
            "port": int(os.environ.get("MEM0_DB_PORT", "5432")),
        },
    },
    "graph_store": {
        "provider": "neo4j",
        "config": {
            "url": os.environ.get("MEM0_GRAPH_STORE_URL", "bolt://mem0-neo4j:7687"),
            "username": "neo4j",
            "password": os.environ.get("MEM0_GRAPH_STORE_PASSWORD", ""),
        },
    },
}

memory = Memory.from_config(config)


class AddRequest(BaseModel):
    messages: list[dict]
    user_id: str | None = None
    agent_id: str | None = None
    metadata: dict | None = None


class SearchRequest(BaseModel):
    query: str
    user_id: str | None = None
    agent_id: str | None = None
    limit: int = 10


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/v1/memories")
def add_memory(req: AddRequest):
    kwargs = {}
    if req.user_id:
        kwargs["user_id"] = req.user_id
    if req.agent_id:
        kwargs["agent_id"] = req.agent_id
    if req.metadata:
        kwargs["metadata"] = req.metadata
    result = memory.add(req.messages, **kwargs)
    return result


@app.post("/v1/memories/search")
def search_memories(req: SearchRequest):
    kwargs = {"limit": req.limit}
    if req.user_id:
        kwargs["user_id"] = req.user_id
    if req.agent_id:
        kwargs["agent_id"] = req.agent_id
    results = memory.search(req.query, **kwargs)
    return results


@app.get("/v1/memories")
def get_all_memories(user_id: str | None = None, agent_id: str | None = None):
    kwargs = {}
    if user_id:
        kwargs["user_id"] = user_id
    if agent_id:
        kwargs["agent_id"] = agent_id
    return memory.get_all(**kwargs)


@app.delete("/v1/memories/{memory_id}")
def delete_memory(memory_id: str):
    memory.delete(memory_id)
    return {"status": "deleted"}

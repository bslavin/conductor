FROM python:3.12-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends libpq-dev gcc && \
    pip install --no-cache-dir \
      mem0ai \
      psycopg2-binary \
      neo4j \
      langchain-neo4j \
      rank-bm25 \
      uvicorn \
      fastapi && \
    apt-get purge -y gcc && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY server.py .

EXPOSE 8080
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8080"]

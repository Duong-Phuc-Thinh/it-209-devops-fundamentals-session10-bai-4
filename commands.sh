#!/bin/bash
set -e

echo "=== 1. Tao Custom Bridge Network: app-net ==="
docker network create app-net || true

echo "=== 2. Tao Named Volume: db-data ==="
docker volume create db-data

echo "=== 3. Khoi chay Database Container (postgres:15-alpine) ==="
docker run -d \
  --name db-server \
  --network app-net \
  -v db-data:/var/lib/postgresql/data \
  -e POSTGRES_DB=testdb \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_PASSWORD=mypassword \
  postgres:15-alpine

echo "Cho PostgreSQL khoi dong..."
sleep 5

echo "=== 4. Khoi chay Backend Container tham gia app-net ==="
docker run -d \
  --name app-container \
  --network app-net \
  -e DB_HOST=db-server \
  -e DB_PORT=5432 \
  -e DB_USER=myuser \
  -e DB_PASSWORD=mypassword \
  -e DB_NAME=testdb \
  python:3.10-alpine sleep infinity

echo "=== 5. Test Data Persistence ==="
echo "--> Them du lieu mau vao Database..."
docker exec -i db-server psql -U myuser -d testdb -c "CREATE TABLE IF NOT EXISTS notes (id SERIAL PRIMARY KEY, title VARCHAR(100));"
docker exec -i db-server psql -U myuser -d testdb -c "INSERT INTO notes (title) VALUES ('Persistent Data Test');"

echo "--> Du lieu hien tai trong db-server:"
docker exec -i db-server psql -U myuser -d testdb -c "SELECT * FROM notes;"

echo "--> Xoa cung container DB (docker rm -f db-server)..."
docker rm -f db-server

echo "--> Khoi chay lai container DB moi voi cung Volume db-data..."
docker run -d \
  --name db-server \
  --network app-net \
  -v db-data:/var/lib/postgresql/data \
  -e POSTGRES_DB=testdb \
  -e POSTGRES_USER=myuser \
  -e POSTGRES_PASSWORD=mypassword \
  postgres:15-alpine

echo "Cho DB container moi khoi chay..."
sleep 5

echo "--> Xac minh du lieu khong bi mat:"
docker exec -i db-server psql -U myuser -d testdb -c "SELECT * FROM notes;"

echo "=== 6. Kiem tra theo yeu cau ==="
echo "[Lenh 1]: docker network ls | grep app-net"
docker network ls | grep app-net

echo "[Lenh 2]: docker volume ls | grep db-data"
docker volume ls | grep db-data

echo "[Lenh 3]: docker network inspect app-net"
docker network inspect app-net

echo "[Lenh 4]: docker exec -i app-container ping -c 2 db-server"
docker exec -i app-container ping -c 2 db-server

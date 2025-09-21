# Connecting to Dockerized PostgreSQL

---

## **Database Details**

| Field          | Value               |
|----------------|---------------------|
| Host           | `postgres`          |
| Port           | `5432`              |
| Database       | `mydb`              |
| Username       | `postgres`          |
| Password       | `1234`              |
| Server Name    | (Anything is fine)  |

> **Note:** The Server Name in pgAdmin is just a label — it can be anything.

---

## Initialise Database
To set up the PostgreSQL environment locally, run:

```bash
# Make sure you are in the main directory, if not, run `cd` ... 
cd PostgreSQL-Docker_Setup
```

Then, start the Docker daemon (open Docker Desktop or run `dockerd` if needed)

### Use the appropriate command for your system:

```bash
## Mac / Windows (Docker Desktop)
docker compose up -d

## Linux (some distributions still use the old binary)
docker-compose up -d
```

## **Using pgAdmin within Docker Container**

1. Open **pgAdmin**, either through Docker Desktop or.  
2. Right-click **Servers → Create → Server**.  
3. **General tab:**  
   - Name: `CITS3200` (or any name you like)  
4. **Connection tab:**  
   - Host name/address: `postgres`  
   - Port: `5432`  
   - Maintenance database: `postgres`  
   - Username: `postgres`  
   - Password: `1234`  
5. Click **Save**.  
6. You should now see the databases
7. Perform a right-click on "mydb" 
8. Select Query Tool (To create SQL Queries)
9. eg. SELECT * from location_type


## Standalone Docker Command (if not using Compose)
docker run -d \
  --name mydb_verVB \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=1234 \
  -e POSTGRES_DB=mydb_verVB \
  -p 5434:5432 \
  -v pgdata:/var/lib/postgresql/data \
  postgres:17

---

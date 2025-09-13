# PostgreSQL Docker Setup - Quick Start

## Instructions

1. **Download the setup**
   - Get the folder containing:
     - `docker-compose.yml`
     - `backup.sql`

2. **Start the Docker containers**
   - Open a terminal or PowerShell in the folder
   - Run:
     ```
     docker-compose up -d
     ```
   - This will start PostgreSQL on **port 5434** and PGAdmin4 on **http://localhost:8080**

3. **Connect using PGAdmin4**
   - Open PGAdmin4
   - Create a new server with:
     - **Host:** localhost
     - **Port:** 5434
     - **Username:** postgres
     - **Password:** 1234
     - **Database:** mydb

4. **Verify your data**
   - Expand the database → Schemas → public → Tables
   - Browse or query the tables to check the backup loaded successfully

5. **Stop the containers (optional)**

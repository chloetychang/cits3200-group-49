# PostgreSQL Docker Setup - Quick Start

## Instructions

1. **Download the setup**
   - Get the folder containing:
     - `docker-compose.yml`
     - `backup.sql`

2. **Start the Docker containers**
   - Open a terminal or PowerShell in the folder "PostgreSQL-Docker_Setup"
   - Run:
     ```
     docker-compose up -d
     ```
   - Alternatively, in the root directory, run:
      ```
      docker-compose -f PostgreSQL-Docker_Setup/docker-compose.yml up -d
      ```
   - This will start PostgreSQL on **port 5434** and PGAdmin4 on **http://localhost:8080**

3. **Connect using PGAdmin4**
   - Open PGAdmin4
   - Create a new server with database credentials as given by administrators

4. **Verify your data**
   - Expand the database → Schemas → public → Tables
   - Browse or query the tables to check the backup loaded successfully

## API Integration with New Database

### Fresh Installation Steps
1. **Delete existing data** (if updating from previous setup):
   ```
   docker-compose down
   rm -rf postgres-data
   ```
   
2. **Update environment credentials**:
   - Make sure to update your `.env` file with the correct database credentials
   - Ensure the database connection parameters match the Docker setup

3. **Restart the containers**:
   ```
   docker-compose up -d
   ```

### Important Notes
- Always delete the `postgres-data` folder when switching to the new database schema
- Verify your `.env` credentials match the Docker configuration before starting the API

5. **Stop the containers (optional)**

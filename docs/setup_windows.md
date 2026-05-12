# FinFlow Windows Setup Guide

This guide explains how to run FinFlow locally on Windows 11.

## Prerequisites

- Windows 11
- VS Code
- Git
- Docker Desktop
- PowerShell
- Python 3.11 or newer

## Project Location

Recommended local path:

```text
C:\Users\suraj\Documents\PortfolioProjects\finflow-data-platform
```

## Environment Variables

Create a local `.env` file from `.env.example`:

```powershell
Copy-Item .env.example .env
```

The `.env` file is ignored by Git and should not be committed.

## PostgreSQL Docker Setup

The local PostgreSQL database runs inside Docker using `docker-compose.yml`.

Database details for local development:

```text
Host: localhost
Port: 5432
Database: finflow
User: finflow_user
Password: stored locally in .env
Container name: finflow-postgres
```

## Start PostgreSQL

From the project root, run:

```powershell
docker compose up -d
```

## Check Running Containers

```powershell
docker ps
```

Expected container:

```text
finflow-postgres
```

## Check Database Health

```powershell
docker inspect --format="{{.State.Health.Status}}" finflow-postgres
```

Expected output:

```text
healthy
```

## Connect to PostgreSQL

```powershell
docker exec -it finflow-postgres psql -U finflow_user -d finflow
```

## Useful PostgreSQL Commands

Check PostgreSQL version:

```sql
SELECT version();
```

Check current database:

```sql
SELECT current_database();
```

Exit PostgreSQL:

```sql
\q
```

## Stop PostgreSQL

```powershell
docker compose down
```

## Stop PostgreSQL and Delete Local Database Volume

Only use this if you want to reset the local database completely:

```powershell
docker compose down -v
```

## Troubleshooting

### Docker Compose cannot read `.env`

If Docker shows an error such as:

```text
failed to read .env
```

Check that `.env` does not contain markdown formatting such as:

````text
```env
````

The `.env` file should contain only environment variable lines, for example:

```env
POSTGRES_DB=finflow
POSTGRES_USER=finflow_user
POSTGRES_PASSWORD=finflow_password
```

### Accidentally created the wrong Docker Compose file

The correct file name is:

```text
docker-compose.yml
```

Not:

```text
docker-compose.ysl
```

import os
import sys

def main():
    print("=== Backend Web API / Database Connection Check ===")
    db_host = os.getenv("DB_HOST", "db-server")
    db_port = os.getenv("DB_PORT", "5432")
    db_user = os.getenv("DB_USER", "myuser")
    db_password = os.getenv("DB_PASSWORD", "mypassword")
    db_name = os.getenv("DB_NAME", "testdb")

    print(f"DB Host: {db_host}")
    print(f"DB Port: {db_port}")
    print(f"DB User: {db_user}")
    print(f"DB Name: {db_name}")

    try:
        import psycopg2
        conn = psycopg2.connect(
            host=db_host,
            port=db_port,
            user=db_user,
            password=db_password,
            dbname=db_name
        )
        cur = conn.cursor()
        cur.execute("SELECT version();")
        db_version = cur.fetchone()
        print(f"Successfully connected to PostgreSQL! Version: {db_version[0]}")
        cur.close()
        conn.close()
    except ImportError:
        print("psycopg2 module not installed. Proceeding with configuration validation.")
    except Exception as e:
        print(f"Failed to connect to database: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()

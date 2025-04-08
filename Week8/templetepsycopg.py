import sys
import psycopg2

conn = None
if len(sys.argv) != 2:
    print('Usage: python3 templetepsycopg.py dbName')
db = sys.argv[1]
try:
    conn = psycopg2.connect(f"dbname={db}")
    print(conn)
    cur = conn.cursor()
except Exception as e:
    print("DB error:", e)
finally:
    if conn is not None:
        conn.close()
        print(conn)
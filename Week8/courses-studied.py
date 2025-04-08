import sys
import psycopg2

conn = None
if len(sys.argv) != 3:
    print('Usage: ./courses-studied studentID term')
    exit(1)

sId, term = sys.argv[1:]
try:
    conn = psycopg2.connect("dbname=uni")
    cur = conn.cursor()

    cur.execute("select * from Students where id = %s", (sId,))
    if not cur.fetchone():
        print("No such student")
        exit(0)

    qry = '''
        select S.code, S.name from Course_enrolments CE
        join Courses C on (C.id = CE.course)
        join Terms T on (T.id = C.term)
        join Subjects S on (S.id = C.subject)
        where CE.student = %s and T.code = %s
        order by S.code
    '''
    cur.execute(qry, (sId, term))

    for code, name in cur.fetchall():
        print(code, name)

except Exception as e:
    print("DB error:", e)
finally:
    if conn is not None:
        conn.close()
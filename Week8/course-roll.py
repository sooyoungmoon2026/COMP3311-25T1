import sys
import psycopg2

conn = None
if len(sys.argv) != 3:
    print('Usage: course-roll subject term')
    exit(1)

courseCode, term = sys.argv[1:]
try:
    conn = psycopg2.connect("dbname=uni")
    cur = conn.cursor()

    cur.execute("select * from Subjects where code = %s", (courseCode,))
    if not cur.fetchone():
        print("Invalid subject", courseCode)
        exit(0)

    cur.execute("select * from Terms where code = %s", (term,))
    if not cur.fetchone():
        print("Invalid term", term)
        exit(0)

    cur.execute('''
        select * from Courses C
        join Subjects S on (S.id = C.subject)
        join Terms T on (T.id = C.term)
        where S.code = %s and T.code ILIKE %s
    ''', (courseCode, term))
    if not cur.fetchone():
        print("No offering:", courseCode, term)
        exit(0)

    print(courseCode, term)

    qry = '''
        select P.id, P.family, P.given from Course_enrolments CE
        join Courses C on (C.id = CE.course)
        join Terms T on (T.id = C.term)
        join Subjects S on (S.id = C.subject)
        join People P on (P.id = CE.student)
        where S.code = %s and T.code = %s
        order by P.family
    '''
    cur.execute(qry, (courseCode, term))

    resultList = cur.fetchall()

    if len(resultList) == 0:
        print("No students")
        exit(0)

    for sId, family, given in resultList:
        print(sId, family + ', ' + given)

except Exception as e:
    print("DB error:", e)
finally:
    if conn is not None:
        conn.close()
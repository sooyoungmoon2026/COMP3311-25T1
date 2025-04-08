import sys
import psycopg2

conn = None
if len(sys.argv) != 2:
    print('Usage: python3 nsubjects.py partialName')
partialName = sys.argv[1]
try:
    conn = psycopg2.connect("dbname=uni")
    cur = conn.cursor()

    pattern = f'School of %{partialName}%'

    cur.execute('''
        select O.longname, count(*) from OrgUnits O
        join Subjects S on (S.offeredby = O.id)
        where O.longname ILIKE %s
        group by O.longname
    ''', (pattern,))

    resultList = cur.fetchall()
    if len(resultList) == 0:
        print('No matches')
        exit(0)
    elif len(resultList) == 1:
        print(resultList[0][0], 'teaches', resultList[0][1], 'subjects')
    else:
        print('Multiple schools match:')
        for schoolName in resultList:
            print(schoolName[0])
except Exception as e:
    print("DB error:", e)
finally:
    if conn is not None:
        conn.close()
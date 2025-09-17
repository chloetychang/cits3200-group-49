#PYOBDC CHECKING 
import pyodbc
import os

#Change to your own directory 
access_file = r'C:\UWA\PROFCOM\DB_Migration\V2.accdb'

if not os.path.exists(access_file):
    raise FileNotFoundError(f"The Access file does not exist: {access_file}")

conn_str = (
    r'DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};'
    r'DBQ=' + access_file + ';'
)

try:
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    print("Tables in the Access database:")
    for row in cursor.tables(tableType='TABLE'):
        print(row.table_name)

except pyodbc.Error as e:
    print("Error connecting to Access database:", e)

finally:
    if 'cursor' in locals():
        cursor.close()
    if 'conn' in locals():
        conn.close()
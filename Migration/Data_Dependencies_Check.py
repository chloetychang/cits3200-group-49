#Checking Dependencies
import pyodbc
print(pyodbc.version)
drivers = [driver for driver in pyodbc.drivers()]
print(drivers)
#Output Should be: 
#['SQL Server', 'Microsoft Access Driver (*.mdb, *.accdb)', 'Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)', 'Microsoft Access Text Driver (*.txt, *.csv)', 'Microsoft Access dBASE Driver (*.dbf, *.ndx, *.mdx)']#










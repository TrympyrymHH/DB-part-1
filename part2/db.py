try:
    import configparser
except ImportError:
    import ConfigParser as configparser
import psycopg2

class dbProperties:
        def __init__(self, fname):
                self.filename = fname
                self.cfgParser = configparser.SafeConfigParser()
                self.cfgParser.read(self.filename)
        def getHost(self):
                return self.cfgParser.get('db_connection','host')
        def getUser(self):
                return self.cfgParser.get('db_connection','user')
        def getPass(self):
                return self.cfgParser.get('db_connection','password')
        def getDB(self):
                return self.cfgParser.get('db_connection','dbname')

class dbConn:
	def __init__(self, fname):
		db_conf = dbProperties(fname)
		self.host = db_conf.getHost()
		self.user = db_conf.getUser()
		self.pasw = db_conf.getPass()
		self.dbname = db_conf.getDB()
	def _execute(self, conn, line):
		self.curs=conn.cursor()
		try:
			self.curs.execute(line)
		except psycopg2.Error as e:
			print('Command skipped: "', line, '"')
			print(e)
	def executeQuery(self, line):
		with psycopg2.connect(host = self.host, user = self.user, password = self.pasw, dbname = self.dbname) as conn:
			self._execute(conn, line)
	def executeText(self, text):
		with psycopg2.connect(host = self.host, user = self.user, password = self.pasw, dbname = self.dbname) as conn:
			sqlCommands = text.split(';')
			for command in sqlCommands:
				command=command.strip()
				if len(command)>0:
					self._execute(conn, command)
	def executeFile(self, fname, *args):
		fd = open(fname, 'r')
		sqlFile = fd.read()
		fd.close()
		sqlFile=sqlFile.format(*args)
		self.executeText(sqlFile)
	def fetchone(self):
		return self.curs.fetchone()
	def fetchall(self):
		return self.curs.fetchall()
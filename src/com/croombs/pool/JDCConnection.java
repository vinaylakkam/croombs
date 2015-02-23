package com.croombs.pool;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.SQLWarning;
import java.sql.Savepoint;
import java.sql.Statement;
import java.util.Map;

public class JDCConnection implements Connection {

    private JDCConnectionPool pool;
    private Connection conn;
    private boolean inuse;
    private long timestamp;


    public JDCConnection(Connection conn, JDCConnectionPool pool) {
        this.conn=conn;
        this.pool=pool;
        this.inuse=false;
        this.timestamp=0;
    }

    public synchronized boolean lease() {
       if(inuse)  {
           return false;
       } else {
          inuse=true;
          timestamp=System.currentTimeMillis();
          return true;
       }
    }
    public boolean validate() {
	try {
            conn.getMetaData();
        }catch (Exception e) {
	    return false;
	}
	return true;
    }

    public boolean inUse() {
        return inuse;
    }

    public long getLastUse() {
        return timestamp;
    }

    public void close() throws SQLException {
        pool.returnConnection(this);
    }

    protected void expireLease() {
        inuse=false;
    }

    protected Connection getConnection() {
        return conn;
    }

    public PreparedStatement prepareStatement(String sql) throws SQLException {
        return conn.prepareStatement(sql);
    }

    public CallableStatement prepareCall(String sql) throws SQLException {
        return conn.prepareCall(sql);
    }

    public Statement createStatement() throws SQLException {
        return conn.createStatement();
    }

    public String nativeSQL(String sql) throws SQLException {
        return conn.nativeSQL(sql);
    }

    public void setAutoCommit(boolean autoCommit) throws SQLException {
        conn.setAutoCommit(autoCommit);
    }

    public boolean getAutoCommit() throws SQLException {
        return conn.getAutoCommit();
    }

    public void commit() throws SQLException {
        conn.commit();
    }

    public void rollback() throws SQLException {
        conn.rollback();
    }

    public boolean isClosed() throws SQLException {
        return conn.isClosed();
    }

    public DatabaseMetaData getMetaData() throws SQLException {
        return conn.getMetaData();
    }

    public void setReadOnly(boolean readOnly) throws SQLException {
        conn.setReadOnly(readOnly);
    }
  
    public boolean isReadOnly() throws SQLException {
        return conn.isReadOnly();
    }

    public void setCatalog(String catalog) throws SQLException {
        conn.setCatalog(catalog);
    }

    public String getCatalog() throws SQLException {
        return conn.getCatalog();
    }

    public void setTransactionIsolation(int level) throws SQLException {
        conn.setTransactionIsolation(level);
    }

    public int getTransactionIsolation() throws SQLException {
        return conn.getTransactionIsolation();
    }

    public SQLWarning getWarnings() throws SQLException {
        return conn.getWarnings();
    }

    public void clearWarnings() throws SQLException {
        conn.clearWarnings();
    }
    //***************************************************************

	public Statement createStatement(int arg0, int arg1) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	public Statement createStatement(int arg0, int arg1, int arg2)
			throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	public int getHoldability() throws SQLException {
		// TODO Auto-generated method stub
		return 0;
	}

	public Map<String, Class<?>> getTypeMap() throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	public CallableStatement prepareCall(String arg0, int arg1, int arg2)
			throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	public CallableStatement prepareCall(String arg0, int arg1, int arg2,
			int arg3) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	public PreparedStatement prepareStatement(String arg0, int arg1)
			throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	public PreparedStatement prepareStatement(String arg0, int[] arg1)
			throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	public PreparedStatement prepareStatement(String arg0, String[] arg1)
			throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	public PreparedStatement prepareStatement(String arg0, int arg1, int arg2)
			throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	public PreparedStatement prepareStatement(String arg0, int arg1, int arg2,
			int arg3) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	public void releaseSavepoint(Savepoint arg0) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	public void rollback(Savepoint arg0) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	public void setHoldability(int arg0) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	public Savepoint setSavepoint() throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	public Savepoint setSavepoint(String arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	public void setTypeMap(Map<String, Class<?>> arg0) throws SQLException {
		// TODO Auto-generated method stub
		
	}
    
    
}

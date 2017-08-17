<%--
    Document   : pdf_print.jsp
    Created on : Feb 12, 2016, 8:55:39 AM
    Author     : Mikhail Mikhailidi
    Mangled by Roger Pilkey, 2017-07-28, for fop 2.2
--%>
<%@ page import='java.io.*' %>
<%@ page import='org.apache.fop.apps.Fop' %>
<%@ page import='org.apache.fop.apps.FopFactory' %>
<%@ page import='org.apache.fop.apps.FopFactoryBuilder' %>
<%@ page import='org.apache.fop.apps.FOUserAgent' %>
<%@ page import='org.apache.fop.apps.MimeConstants' %>
<%@ page import='javax.xml.transform.Result' %>
<%@ page import='javax.xml.transform.Source' %>
<%@ page import='javax.xml.transform.sax.SAXResult' %>
<%@ page import='javax.xml.transform.TransformerFactory' %>
<%@ page import='javax.xml.transform.Transformer' %>
<%@ page import='javax.xml.transform.stream.StreamSource' %>
<%--required for using a config file--%>
<%--<%@ page import='org.apache.avalon.framework.configuration.Configuration' %>--%>
<%--<%@ page import='org.apache.avalon.framework.configuration.DefaultConfigurationBuilder' %>--%>
<%

// original: https://xmlgraphics.apache.org/fop/2.2/servlets.html
//private TransformerFactory tFactory = TransformerFactory.newInstance();
// RP: error, ok, so try not private...
TransformerFactory tFactory = TransformerFactory.newInstance();

// Construct a FopFactory by specifying a reference to a configuration file
// (reuse if you plan to render multiple documents!)
// RP: I think this would be reused by putting it in a jsp declaration (<%!...) but it doesn't seem to matter
FopFactory fopFactory = FopFactory.newInstance(new File(".").toURI());

//use a configuration file
//RP: setting accessibility in conf file seems to be ignored...
//DefaultConfigurationBuilder cfgBuilder = new DefaultConfigurationBuilder();
//Configuration cfg = cfgBuilder.buildFromFile(new File("webapps/fop/fop.accessible.conf"));
//FopFactoryBuilder fopFactoryBuilder = new FopFactoryBuilder(new File(".").toURI()).setConfiguration(cfg);
//FopFactory fopFactory = fopFactoryBuilder.build();

// do the following for each new rendering run
FOUserAgent userAgent = fopFactory.newFOUserAgent();
// customize userAgent
//userAgent.setAccessibility(true);

//Setup a buffer to obtain the content length
ByteArrayOutputStream v_out = new ByteArrayOutputStream();

//Setup FOP
//RP: MimeConstants.MIME_PDF cannot resolve ? Solution: make sure all fop/lib. jar files are in lib/ and restart Tomcat.
Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, userAgent, v_out);

//Setup Transformer
Source xsltSrc = new StreamSource( new java.io.StringReader(request.getParameter("template")));

Transformer transformer = tFactory.newTransformer(xsltSrc);

//Make sure the XSL transformation's result is piped through to FOP
Result res = new SAXResult(fop.getDefaultHandler());

//Setup input
Source src = new StreamSource(new java.io.StringReader(request.getParameter("xml")));

//Start the transformation and rendering process
transformer.transform(src, res);

//Prepare response
response.setContentType(MimeConstants.MIME_PDF);
response.setContentLength(v_out.size());

//Send content to Browser
response.getOutputStream().write(v_out.toByteArray());
response.getOutputStream().flush();
response.getOutputStream().close();
%>

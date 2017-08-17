# Apache FOP Servlet

This servlet has been developed as the replacement for the original Oracle FOP servlet for Apex reports.
It could be configured with Oracle Apex 5 Reports and to generate PDF documents from the XML data and XSLT templates. APEX 5 configuration details could be found [here](http://blog.mmikhail.com/2016/02/apex-50-and-apache-fop.html) 

Servlet accepts two parameters as below:

Name | Description
-------|------------------------
__xml__ | Data in XML format to be printed.
__template__ | XSLT template to generate XSL-FO document

### Servlet calls
* For __GET__ request parameter values should be URL-encoded. 
  Sample URL   http://localhost:8080/Apex5Fop/pdf_print.jsp?xml=…&template=… 
* For __POST__ requests data should be HTML-encoded


------
Special thanks to @RogerPilkey, who has adapted the JSP code to FOP 2.2 


<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.kit418.web.WebConnector" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import="java.util.Iterator" %>
<%
WebConnector httpclient = new WebConnector();
Map<String,String> result = httpclient.sendGet("http://localhost:8080/PaaS_WS/InstanceControl");
%>
<%@include  file="header.html" %>    

<%
if (!result.get("ResponseCode").equals("200")) {
%>
<h2>Error Occur</h2>
<p><% out.print(result.get("ResponseCode") + ": " + result.get("ResponseMsg")); %></p>
<%
}
else 
{
	JSONObject jo = (JSONObject) new JSONParser().parse(result.get("ResponseMsg"));
	JSONArray ja = (JSONArray) jo.get("ServerList"); 
%>
<!-- body here -->
<div class="container-flui">
  <div class="card mt-5">
    <div class="card-header">
      <h2>Worker List</h2>
    </div>
    <div class="card-body">
      <table id="dtBasicExample" class="table table-striped table-bordered" cellspacing="0" width="100%">
        <thead>
            <tr>
              <th class="th-sm export">ID</th>
              <th class="th-sm export">Server Name</th>
              <th class="th-sm export">IP Address</th>
              <th class="th-sm export">Status</th>
              <th class="th-sm export">Action</th>
            </tr>
        </thead>
        <tbody>
        <%
        for (int i = 0; i < ja.size(); i++) {
            JSONObject instance = (JSONObject) ja.get(i);
        %>
        	<tr>
	                <td><% out.print(instance.get("id")); %></td>
	                <td><% out.print(instance.get("name")); %></td>
	                <td><% out.print(instance.get("ipv4")); %></td>
	                <td><% out.print(instance.get("status")); %></td>
	                <% if (instance.get("name").toString().contains("master")) { %>
	                	<td></td>
	                <% } else { %>
		                <% if (instance.get("status").toString().equals("ACTIVE"))  { %>
		                	<td><a href="#" class="btn btn-danger" role="button">Stop Server</a></td>
		                <% } else { %>
		                	<td><a href="#" class="btn btn-success" role="button">Start Server</a></td>
		                <% } %>
		            <% } %>
	              </tr>
			<% } %>
        </tbody>
     
      </table>
    </div>
  </div>
</div>
<%} %>
<!-- footer here -->
<%@include  file="footer.html" %>

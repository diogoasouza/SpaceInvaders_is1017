<%-- 
    Document   : register
    Created on : Mar 24, 2016, 4:16:56 PM
    Author     : diogo
--%>

<%@page import="edu.pitt.is1017.spaceinvaders.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Alien Invaders - Register</title>
    </head>
    <%
        String userName = "";
        String password = "";
        String confirmPassword = "";
        String firstName = "";
        String lastName = "";
        User user;
        if (request.getParameter("submit") != null) {
            if (request.getParameter("txtUserName") != null && request.getParameter("txtPassword") != null
                    && request.getParameter("txtFirstName") != null && request.getParameter("txtLastName") != null
                    && request.getParameter("txtConfirmPassword") != null) {
                userName = request.getParameter("txtUserName");
                password = request.getParameter("txtPassword");
                confirmPassword = request.getParameter("txtConfirmPassword");
                firstName = request.getParameter("txtFirstName");
                lastName = request.getParameter("txtLastName");
                if (!userName.equals("") && !password.equals("") && !firstName.equals("") && !lastName.equals("") && !confirmPassword.equals("")) {
                    if (confirmPassword.equals(password)) {
                        user = new User(lastName, firstName, userName, password);
                        out.print("<script>alert('User registered!')</script>");
                    } else {
                        out.print("<script>alert('Enter the same password in both fields!')</script>");
                    }

                } else {
                    out.print("<script>alert('No field can be empty!')</script>");
                }
            }
        }
        if (request.getParameter("login") != null) {
            response.sendRedirect("login.jsp");
        }

    %> 
    <style>
        .btn{
            width:50%;
        }
    </style>
    <body>
        <form id="register" action ="register.jsp" method="post">
            <table align="center">
                <tr>
                    <td><label for="txtFirstName">First name: </label></td>
                    <td><input type="text" name="txtFirstName"/></td>
                </tr>
                <tr>
                    <td><label for="txtLastName">Last name: </label></td>
                    <td><input type="text" name="txtLastName"/></td>
                </tr>
                <tr>
                    <td><label for="txtUserName">User name: </label> </td>
                    <td><input type="text" name="txtUserName"/></td>
                </tr>
                <tr>
                    <td><label for="txtPassword">Password: </label></td>
                    <td><input type="password" name="txtPassword"/></td>
                </tr>
                <tr>
                    <td><label for="txtConfirmPassword">Confirm password: </label></td>
                    <td><input type="password" name="txtConfirmPassword"/></td>
                </tr>
                <tr>
                    <td colspan="2" align="center"><input type="submit" name="submit" value="Register"></td>
                </tr>
            </table>
        </form>
    </body>
</html>


<%@page import="edu.pitt.is1017.spaceinvaders.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Space Invaders - Login</title>
    </head>
    <%
        String userName = "";
        String password = "";
        User user;
        if (request.getParameter("submit") != null) {
            if (request.getParameter("txtUserName") != null && request.getParameter("txtPassword") != null) {
                userName = request.getParameter("txtUserName");
                password = request.getParameter("txtPassword");
                if (!userName.equals("") && !password.equals("")) {
                    user = new User(userName, password);
                    if (user.isLoggedIn()) {
                        //redirect to game.jsp
                        response.sendRedirect("game.jsp?userID="+user.getUserID());
                    } else {
                        out.print("<script>alert('Invalid email or password')</script>");
                    }
                } else {
                    out.print("<script>alert('User name and password must not be empty!')</script>");
                }
            }
        }
        if (request.getParameter("register") != null) {
            response.sendRedirect("register.jsp");
        }

    %>    
    <body>
        <form id="login" action ="index.jsp" method="post">
            <table align="center">
                <tr>
                    <td><label for="txtUserName">User name: </label> </td>
                    <td><input type="text" name="txtUserName"/></td>
                </tr>
                <tr>
                    <td><label for="txtPassword">Password: </label></td>
                    <td><input type="password" name="txtPassword"/></td>
                </tr>
                <tr>
                    <td align="center"><input type="submit" name="submit" value="Login"></td>
                    <td align="center"><input type="submit" name="register" value="Register"></td>
                </tr>
            </table>
            
        </form>
    </body>
</html>

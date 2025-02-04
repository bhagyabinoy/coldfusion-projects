<cfscript>

users = createObject("component", "components.Users");
username = trim(form.username);
password = trim(form.password);
rememberMe = structKeyExists(form, "rememberMe") and form.rememberMe eq "true";
result = users.authenticateUser(username, password);

if (result.success) {
    sessionToken = createUUID();
    session.user = {
        id: result.user.user_id,
        username: result.user.username,
        role: result.user.role,
        sessionToken: sessionToken
    };

    users.storeSessionToken(result.user.user_id, sessionToken);
    if (rememberMe) {
        cookie.sessionToken = sessionToken;
        cookie.setExpire("30"); 
    }
    switch (session.user.role) {
        case "admin":
            location(url="adminDashboard.cfm");
            break;
        case "teacher":
            location(url="teacherDashboard.cfm");
            break;
        case "parent":
            location(url="parentDashboard.cfm");
            break;
        case "student":
            location(url="studentDashboard.cfm");
            break;
        default:
            location(url="homepage.cfm");
    }
} else {
    session.loginError = result.message;
    location(url="login.cfm");
}

</cfscript>

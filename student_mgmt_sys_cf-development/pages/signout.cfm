<cfscript>
 
    if (structKeyExists(session, "user")) {
 
        structDelete(session, "user");

        if (structKeyExists(cookie, "sessionToken")) {
            cookie.sessionToken = "";
        }
    }
    
    location(url="login.cfm");
</cfscript>

<cfcomponent>

    <!--- Function to authenticate a user based on username and password --->
    <cffunction name="authenticateUser" access="public" returntype="struct" output="false">
        <cfargument name="username" type="string" required="true">
        <cfargument name="password" type="string" required="true">
        
        <cfset var result = structNew()>
        <cfset var query = "">
        <cfset var passwordHash = hash(arguments.password, "SHA-256")>
        
        <cfset query = "
            SELECT user_id, username, role
            FROM users
            WHERE username = :username
            AND password = :passwordHash
        ">
        
        <cftry>
            <cfset queryResult = queryExecute(query, {
                username: arguments.username,
                passwordHash: passwordHash
            }, {datasource="studentmgmtdb"})>
            
            <!--- Check if user exists --->
            <cfif queryResult.recordCount gt 0>
                <!--- User authenticated --->
                <cfset result.user = {
                    user_id: queryResult.USER_ID[1],
                    username: queryResult.USERNAME[1],
                    role: queryResult.ROLE[1]
                }> 
                <cfset result.success = true>
            <cfelse>
                <!--- Invalid credentials --->
                <cfset result.success = false>
                <cfset result.message = "Invalid username or password.">
            </cfif>
        <cfcatch type="any">
            <cfset result.success = false>
            <cfset result.message = "An error occurred while processing your request.">
        </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>

    <cffunction name="validateSessionToken" access="public" returntype="struct" output="false">
        <cfargument name="sessionToken" type="string" required="true">
        
        <cfset var result = structNew()>
        <cfset var query = "">
        
        <cfset query = "
            SELECT user_id, username, role
            FROM users
            WHERE auth_token = :sessionToken
        ">
        
        <cftry>
            <cfset result = queryExecute(query, {
                sessionToken: arguments.sessionToken
            }, {datasource="studentmgmtdb"})>
            
            <cfif result.recordCount gt 0>
                <cfset result.user = result[1]> 
                <cfset result.success = true>
            <cfelse>
                <cfset result.success = false>
                <cfset result.message = "Invalid or expired session token.">
            </cfif>
        <cfcatch type="any">
            <cfset result.success = false>
            <cfset result.message = "An error occurred while validating the session token.">
        </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>

    <cffunction name="storeSessionToken" access="public" returntype="void" output="false">
        <cfargument name="userId" type="numeric" required="true">
        <cfargument name="sessionToken" type="string" required="true">
        
        <cftry>
            <cfquery datasource="studentmgmtdb">
                UPDATE users
                SET auth_token = <cfqueryparam value="#arguments.sessionToken#" cfsqltype="cf_sql_varchar">, updated_on = CURRENT_TIMESTAMP
                WHERE user_id = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer">
            </cfquery>
        <cfcatch type="any">
            <cfthrow message="Error storing session token: #cfcatch.message#">
        </cfcatch>
        </cftry>
    </cffunction>


</cfcomponent>

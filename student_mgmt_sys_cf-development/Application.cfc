<cfcomponent>
    <cfset this.name = "StudentMgmtApp">
    <cfset this.applicationTimeout = createTimeSpan(0, 0, 30, 0)>
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout = createTimeSpan(0, 0, 20, 0)>
    <cfset this.setClientCookies = true>

    <cffunction name="onApplicationStart" returntype="boolean" access="public">
        <cfscript>
            // Application-level initialization code
            application.startTime = now();
            this.datasources["studentmgmtdb"] = {
                class: "org.postgresql.Driver", 
                bundleName: "org.postgresql.jdbc", 
                bundleVersion: "42.6.0",
                connectionString: "jdbc:postgresql://172.19.0.1:5436/studentmgmtdb",
                username: "postgres",
                password: "encrypted:ba1b270f1e7092860c7e0ab46793501daa48523368f75e89f9d05869ca74244f",
      
                connectionLimit:-1,
                liveTimeout:15, 
                validate:false,
            };
            this.mappings["/components"] = "/home//Documents/sms_cf/components";
            return true;
        </cfscript>
    </cffunction>

    <cffunction name="onSessionStart" returntype="void" access="public">
        <cfscript>
            // Session-level initialization code
            session.startTime = now();
        </cfscript>
    </cffunction>

    <cffunction name="onRequestStart">
        <cfargument name="targetPage" type="string" required="true">
        <cfif len(arguments.targetPage) EQ 0>
            <cflocation url="pages/login.cfm">
        </cfif>
    </cffunction>

    <cffunction name="onRequest" returntype="void" access="public">
        <cfargument name="targetPage" type="string" required="true">
        <cftry>
            <cfinclude template="#arguments.targetPage#">
            <cfcatch type="any">
                <cflog file="application" text="Error including template: #cfcatch.message#">
                <cfinclude template="pages/error.cfm">
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="onRequestEnd" returntype="void" access="public">
        <cfscript>
            // Code to run at the end of each request
        </cfscript>
    </cffunction>
</cfcomponent>

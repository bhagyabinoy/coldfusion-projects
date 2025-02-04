<cfcomponent displayname="TeacherService">

    <!--- Method to Create a Teacher --->
    <cffunction name="createTeacher" access="remote" returntype="string" output="false">

        <cfargument name="name" type="string" required="true">
        <cfargument name="address" type="string" required="false" default="">
        <cfargument name="phone" type="string" required="false" default="">
        <cfargument name="email" type="string" required="false" default="">
        <cfargument name="date_of_birth" type="date" required="false" default="">
        <cfargument name="gender" type="string" required="false" default="">
        <cfargument name="username" type="string" required="true">
        <cfargument name="password" type="string" required="true">

        <cfif len(arguments.name) EQ 0>
            <cfreturn "Name cannot be empty.">
        </cfif>

        <cfif len(arguments.email) GT 0 AND NOT isValid("email", arguments.email)>
            <cfreturn "Invalid email format.">
        </cfif>

        <cfquery datasource="studentmgmtdb" name="checkUsername">
            SELECT COUNT(*) AS username_count
            FROM public.users
            WHERE username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" maxlength="255">
        </cfquery>

        <cfif checkUsername.username_count GT 0>
            <cfreturn "Username already exists. Please choose a different username.">
        </cfif>
        <cfset passwordHash = hash(arguments.password, "SHA-256")>
        <cfquery datasource="studentmgmtdb" name="insertTeacher">
            INSERT INTO public.teachers (name, address, phone, email, date_of_birth, gender)
            VALUES (
                <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar" maxlength="255">,
                <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_text">,
                <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar" maxlength="20">,
                <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" maxlength="255">,
                <cfqueryparam value="#arguments.date_of_birth#" cfsqltype="cf_sql_date">,
                <cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_varchar" maxlength="15">
            )
        </cfquery>

        <cfquery datasource="studentmgmtdb" name="insertUser">
            INSERT INTO public.users (username, password, role, email)
            VALUES (
                <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" maxlength="255">,
                <cfqueryparam value="#passwordHash#" cfsqltype="cf_sql_varchar" maxlength="255">,
                <cfqueryparam value="teacher" cfsqltype="cf_sql_varchar" maxlength="50">,
                <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" maxlength="255">
            )
        </cfquery>
        <cfreturn "Teacher created successfully!">
    </cffunction>


    <!--- Method to Update a Teacher --->
    <cffunction name="updateTeacher" access="remote" returntype="string">
        <cfargument name="teacher_id" type="numeric" required="true" hint="ID of the teacher to update">
        <cfargument name="name" type="string" required="false" default="" hint="Name of the teacher">
        <cfargument name="address" type="string" required="false" default="" hint="Address of the teacher">
        <cfargument name="phone" type="string" required="false" default="" hint="Phone number of the teacher">
        <cfargument name="email" type="string" required="false" default="" hint="Email address of the teacher">
        <cfargument name="date_of_birth" type="date" required="false" default="" hint="Date of birth of the teacher">
        <cfargument name="gender" type="string" required="false" default="" hint="Gender of the teacher">
        
        <!--- Set the current timestamp for the update --->
        <cfset var updated_on = now()>

        <cfquery datasource="studentmgmtdb" name="updateTeacherQuery">
            UPDATE teachers
            SET 
                name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar" maxlength="255" null="#not len(arguments.name)#">,
                address = <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_text" null="#not len(arguments.address)#">,
                phone = <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar" maxlength="20" null="#not len(arguments.phone)#">,
                email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" maxlength="255" null="#not len(arguments.email)#">,
                date_of_birth = <cfqueryparam value="#arguments.date_of_birth#" cfsqltype="cf_sql_date" null="#not len(arguments.date_of_birth)#">,
                gender = <cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_varchar" maxlength="15" null="#not len(arguments.gender)#">,
                updated_on = <cfqueryparam value="#updated_on#" cfsqltype="cf_sql_timestamp">
            WHERE 
                teacher_id = <cfqueryparam value="#arguments.teacher_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn "Teacher updated successfully!">
    </cffunction>

    <!--- Method to retrieve a Teacher --->
    <cffunction name="getTeacher" access="remote" returntype="query">
        <cfargument name="teacher_id" type="numeric" required="true">

        <cfquery datasource="studentmgmtdb" name="getTeacherQuery">
            SELECT 
                teacher_id, name, address, phone, email, date_of_birth, gender, updated_on
            FROM 
                teachers
            WHERE 
                teacher_id = <cfqueryparam value="#arguments.teacher_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn getTeacherQuery>
    </cffunction>

    <!--- Method to delete a Teacher --->
    <cffunction name="deleteTeacherById" access="remote" returntype="string" output="false">
        <cfargument name="teacher_id" type="numeric" required="true">

        <cfquery name="deleteTeacher" datasource="studentmgmtdb">
            DELETE 
            FROM teachers
            WHERE teacher_id = <cfqueryparam value="#arguments.teacher_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn "Teacher deleted successfully!">
    </cffunction>
</cfcomponent>

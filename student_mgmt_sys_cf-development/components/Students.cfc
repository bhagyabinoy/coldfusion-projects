<cfcomponent>

    <!--- Function to add a new student record --->
    <cffunction name="addStudent" access="remote" returntype="string">
        <cfargument name="name" type="string" required="true">
        <cfargument name="address" type="string" required="false" default="">
        <cfargument name="phone" type="string" required="false" default="">
        <cfargument name="email" type="string" required="false" default="">
        <cfargument name="date_of_birth" type="date" required="false" default="">
        <cfargument name="gender" type="string" required="false" default="">
        <cfargument name="date_of_joining" type="date" required="false" default="">
        <cfargument name="username" type="string" required="true">
        <cfargument name="password" type="string" required="true">

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

        <cfquery datasource="studentmgmtdb" name="checkemail">
            SELECT COUNT(*) AS username_count
            FROM public.users
            WHERE email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" maxlength="255">
        </cfquery>

        <cfif checkUsername.username_count GT 0>
            <cfreturn "Email address already exists. Please choose a different one.">
        </cfif>

        <cfset passwordHash = hash(arguments.password, "SHA-256")>
        <cfset var result = "">

        <cftry>
            <cfquery datasource="studentmgmtdb" name="insertStudentQuery">
                INSERT INTO students 
                (name, address, phone, email, date_of_birth, gender, date_of_joining)
                VALUES
                (
                    <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar" maxlength="255" />,
                    <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_text" />,
                    <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar" maxlength="20" />,
                    <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" maxlength="255" />,
                    <cfqueryparam value="#arguments.date_of_birth#" cfsqltype="cf_sql_date" null="#NOT len(arguments.date_of_birth)#" />,
                    <cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_char" />,
                    <cfqueryparam value="#arguments.date_of_joining#" cfsqltype="cf_sql_date" null="#NOT len(arguments.date_of_joining)#" />
                )
            </cfquery>
            <cfquery datasource="studentmgmtdb" name="insertUser">
                INSERT INTO public.users (username, password, role, email)
                VALUES (
                    <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" maxlength="255">,
                    <cfqueryparam value="#passwordHash#" cfsqltype="cf_sql_varchar" maxlength="255">,
                    <cfqueryparam value="student" cfsqltype="cf_sql_varchar" maxlength="50">,
                    <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" maxlength="255">
                )
            </cfquery>
            <cfset result = "Registered student successfully">
        <cfcatch type="any">
            <cflog file="error" text="Error adding student: #cfcatch.message#">
            <cfset result = "Error: #cfcatch.message#">
        </cfcatch>
        </cftry>

        <cfreturn result>
    </cffunction>


    <!--- Function to update an existing student record --->
    <cffunction name="updateStudent" access="remote" returntype="string">
        <cfargument name="student_id" type="numeric" required="true">
        <cfargument name="name" type="string" required="false" default="">
        <cfargument name="address" type="string" required="false" default="">
        <cfargument name="phone" type="string" required="false" default="">
        <cfargument name="email" type="string" required="false" default="">
        <cfargument name="date_of_birth" type="date" required="false" default="">
        <cfargument name="gender" type="string" required="false" default="">
        <cfargument name="date_of_joining" type="date" required="false" default="">

        <cfif len(arguments.email) GT 0 AND NOT isValid("email", arguments.email)>
            <cfreturn "Invalid email format.">
        </cfif>

        <cfset var result = "">

        <cftry>
            <cfquery datasource="studentmgmtdb" name="updateStudentQuery">
                UPDATE students 
                SET 
                    name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar" maxlength="255">,
                    address = <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_text">,
                    phone = <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar" maxlength="20">,
                    email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" maxlength="255">,
                    date_of_birth = <cfqueryparam value="#arguments.date_of_birth#" cfsqltype="cf_sql_date" null="#NOT len(arguments.date_of_birth)#">,
                    gender = <cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_char">,
                    date_of_joining = <cfqueryparam value="#arguments.date_of_joining#" cfsqltype="cf_sql_date" null="#NOT len(arguments.date_of_joining)#">
                WHERE student_id = <cfqueryparam value="#arguments.student_id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfset result = "Student updated successfully">
        <cfcatch type="any">
            <cflog file="error" text="Error updating student: #cfcatch.message#">
            <cfset result = "Error: #cfcatch.message#">
        </cfcatch>
        </cftry>

        <cfreturn result>
    </cffunction>

    <!--- Function to delete a student record --->
    <cffunction name="deleteStudent" access="remote" returntype="string">
        <cfargument name="student_id" type="numeric" required="true">

        <cfset var result = "">

        <cftry>
            <cfquery datasource="studentmgmtdb" name="deleteStudentQuery">
                DELETE FROM students 
                WHERE student_id = <cfqueryparam value="#arguments.student_id#" cfsqltype="cf_sql_integer">
            </cfquery>

            <cfset result = "Student deleted successfully">
        <cfcatch type="any">
            <cflog file="error" text="Error deleting student: #cfcatch.message#">
            <cfset result = "Error: #cfcatch.message#">
        </cfcatch>
        </cftry>

        <cfreturn result>
    </cffunction>

    <!--- Function to get a student record by student id--->
    <cffunction name="getStudentById" access="remote" returntype="struct">
        <cfargument name="student_id" type="numeric" required="true">

        <cfset var studentData = {}>

        <cftry>
            <cfquery datasource="studentmgmtdb" name="getStudentQuery">
                SELECT student_id, name, address, phone, email, date_of_birth, gender, date_of_joining
                FROM students
                WHERE student_id = <cfqueryparam value="#arguments.student_id#" cfsqltype="cf_sql_integer">
            </cfquery>

            <cfif getStudentQuery.recordcount GT 0>
                <cfset studentData = {
                    "student_id" = getStudentQuery.student_id,
                    "name" = getStudentQuery.name,
                    "address" = getStudentQuery.address,
                    "phone" = getStudentQuery.phone,
                    "email" = getStudentQuery.email,
                    "date_of_birth" = dateformat(getStudentQuery.date_of_birth, "yyyy-mm-dd"),
                    "gender" = getStudentQuery.gender,
                    "date_of_joining" = dateformat(getStudentQuery.date_of_joining, "yyyy-mm-dd")
                }>
            <cfelse>
                <cfreturn { "error" = "Student not found" }>
            </cfif>
            <cfcatch type="any">
            <cfreturn { "error" = "Error: #cfcatch.message#" }>
        </cfcatch>
        </cftry>

        <cfreturn studentData>
    </cffunction>

    <cffunction name="getStudentsByCourse" access="remote" returntype="array">
        <cfargument name="courseId" type="numeric" required="true">

        <cfquery name="students" datasource="studentmgmtdb">
            SELECT s.student_id, s.name AS student_name
            FROM students s
            INNER JOIN enrollments e ON s.student_id = e.student_id
            WHERE e.course_id = <cfqueryparam value="#arguments.courseId#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfset studentArray = []>

        <cfloop query="students">
            <cfset arrayAppend(studentArray, {
                studentId: students.student_id,
                studentName: students.student_name
            })>
        </cfloop>

        <cfreturn studentArray>
    </cffunction>

    <!--- Function to get email by username from the users table --->
    <cffunction name="getEmailByUsername" access="public" returntype="string">
        <cfargument name="username" type="string" required="true">
        
        <cfquery name="userQuery" datasource="studentmgmtdb">
            SELECT email
            FROM users
            WHERE username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">
        </cfquery>
        
        <cfreturn userQuery.email>
    </cffunction>

    <!--- Function to get student details by email from the students table --->
    <cffunction name="getStudentDetailsByEmail" access="public" returntype="struct">
        <cfargument name="email" type="string" required="true">

        <cfset var studentDetails = structNew()>

        <cfquery name="studentQuery" datasource="studentmgmtdb">
            SELECT 
                student_id,
                name,
                address,
                phone,
                email,
                date_of_birth,
                gender,
                date_of_joining,
                created_on,
                updated_on
            FROM students
            WHERE email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!--- Check if student exists and return details --->
        <cfif studentQuery.recordCount>
            <cfset studentDetails = {
                student_id = studentQuery.student_id,
                name = studentQuery.name,
                address = studentQuery.address,
                phone = studentQuery.phone,
                email = studentQuery.email,
                date_of_birth = studentQuery.date_of_birth,
                gender = studentQuery.gender,
                date_of_joining = studentQuery.date_of_joining,
                created_on = studentQuery.created_on,
                updated_on = studentQuery.updated_on
            }>
        </cfif>

        <cfreturn studentDetails>
    </cffunction>

</cfcomponent>

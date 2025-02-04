<cfcomponent>

    <!--- Function to add a new enrollment record --->
    <cffunction name="addEnrollment" access="remote" returntype="string">
        <cfargument name="course_id" type="numeric" required="true">
        <cfargument name="student_id" type="numeric" required="true">
        <cfargument name="start_date" type="date" required="true">
        <cfargument name="end_date" type="date" required="false" default="">

        <cfif NOT isValid("date", arguments.start_date)>
            <cfreturn "Invalid start date format.">
        </cfif>
        <cfif len(arguments.end_date) GT 0 AND NOT isValid("date", arguments.end_date)>
            <cfreturn "Invalid end date format.">
        </cfif>

        <cfset var result = "">

        <cftry>
            <cfquery datasource="studentmgmtdb" name="insertEnrollment">
                INSERT INTO enrollments 
                (course_id, student_id, start_date, end_date)
                VALUES
                (
                    <cfqueryparam value="#arguments.course_id#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.student_id#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.start_date#" cfsqltype="cf_sql_date">,
                    <cfqueryparam value="#arguments.end_date#" cfsqltype="cf_sql_date" null="#NOT len(arguments.end_date)#">
                )
            </cfquery>
            <cfset result = "Enrollment added successfully">
        <cfcatch type="any">
            <cflog file="error" text="Error adding enrollment: #cfcatch.message#">
            <cfset result = "Error: #cfcatch.message#">
        </cfcatch>
        </cftry>

        <cfreturn result>
    </cffunction>

    <!--- getEnrollmentDetailsByStudentID--->
    <cffunction name="getEnrollmentDetailsByStudentID" access="remote" returntype="struct">
        <cfargument name="student_id" type="numeric" required="true">

        <!-- Initialize the result and enrollments array -->
        <cfset var result = structNew()>
        <cfset var enrollments = []>

        <cftry>
            
            <cfquery name="enrollmentQuery" datasource="studentmgmtdb">
                SELECT 
                    course_id,
                    start_date,
                    end_date
                FROM enrollments
                WHERE student_id = <cfqueryparam value="#arguments.student_id#" cfsqltype="cf_sql_integer">
            </cfquery>

            <!-- If enrollments are found -->
            <cfif enrollmentQuery.recordCount GT 0>
                <cfset result.enrollments = []>

                <!-- Loop through the enrollments and fetch course details -->
                <cfloop query="enrollmentQuery">
                    <!-- Second Query: Get course details by course_id -->
                    <cfquery name="courseQuery" datasource="studentmgmtdb">
                        SELECT 
                            course_name,
                            description
                        FROM courses
                        WHERE course_id = <cfqueryparam value="#enrollmentQuery.course_id#" cfsqltype="cf_sql_integer">
                    </cfquery>

                    <!-- Append course and enrollment details into the result -->
                    <cfset arrayAppend(result.enrollments, {
                        course_id = enrollmentQuery.course_id,
                        course_name = courseQuery.course_name,
                        description = courseQuery.description,
                        start_date = enrollmentQuery.start_date,
                        end_date = enrollmentQuery.end_date
                    })>
                </cfloop>
            <cfelse>
                <!-- No enrollments found for the student -->
                <cfset result.message = "No enrollments found for the student.">
            </cfif>

        <!-- Error handling -->
        <cfcatch type="any">
            <cflog file="error" text="Error retrieving enrollment details: #cfcatch.message#">
            <cfset result.message = "Error retrieving enrollment details: #cfcatch.message#">
        </cfcatch>
        </cftry>

        <!-- Return the result structure -->
        <cfreturn result>
    </cffunction>



</cfcomponent>

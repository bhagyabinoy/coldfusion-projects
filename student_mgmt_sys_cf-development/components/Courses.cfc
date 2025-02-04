<cfcomponent displayname="CourseService" hint="Service for managing courses">

    <!--- Method to Create a New Course --->
    <cffunction name="addCourse" access="remote" returntype="string" output="false">
        <cfargument name="courseName" type="string" required="true">
        <cfargument name="description" type="string" required="false" default="">

        <cfquery datasource="studentmgmtdb" name="insertCourse">
            INSERT INTO public.courses (course_name, description)
            VALUES (
                <cfqueryparam value="#arguments.courseName#" cfsqltype="cf_sql_varchar" maxlength="255">,
                <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_text">
            )
        </cfquery>
        
        <cfreturn "Course added successfully!">
    </cffunction>

    <!--- Method to Update a Course --->
    <cffunction name="updateCourse" access="remote" returntype="string" output="false">
        <cfargument name="courseId" type="numeric" required="true">
        <cfargument name="courseName" type="string" required="true">
        <cfargument name="description" type="string" required="false" default="">

        <cftry>
            <!--- Ensure the SQL query is correctly formatted and safe from SQL injection. --->
            <cfquery datasource="studentmgmtdb" name="updateCourse">
                UPDATE public.courses
                SET course_name = <cfqueryparam value="#arguments.courseName#" cfsqltype="cf_sql_varchar" maxlength="255">,
                    description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_text">,
                    updated_on = now()
                WHERE course_id = <cfqueryparam value="#arguments.courseId#" cfsqltype="cf_sql_integer">
            </cfquery>

            <!--- Return success message if query executes successfully. --->
            <cfreturn "Course updated successfully!">

            <cfcatch type="database">
                <!--- Return error message if there is a database error. --->
                <cfreturn "Error updating course: #cfcatch.message#">
            </cfcatch>

            <cfcatch type="any">
                <!--- Return generic error message for any other issues. --->
                <cfreturn "An unexpected error occurred: #cfcatch.message#">
            </cfcatch>
        </cftry>
    </cffunction>

    <!--- Method to Retrieve a Course --->
    <cffunction name="getCourse" access="remote" returntype="struct" output="false">
        <cfargument name="courseId" type="numeric" required="true">

        <!--- Define a structure to hold the course details. --->
        <cfset var courseDetails = {}>

        <cftry>
            <!--- Query the database to retrieve course details. --->
            <cfquery datasource="studentmgmtdb" name="courseQuery">
                SELECT course_name, description, updated_on
                FROM public.courses
                WHERE course_id = <cfqueryparam value="#arguments.courseId#" cfsqltype="cf_sql_integer">
            </cfquery>

            <!--- Check if a course was found. --->
            <cfif courseQuery.recordCount gt 0>
                <!--- Populate the structure with course details. --->
                <cfset courseDetails.courseName = courseQuery.course_name>
                <cfset courseDetails.description = courseQuery.description>
                <cfset courseDetails.updatedOn = courseQuery.updated_on>
            <cfelse>
                <!--- Handle the case where no course was found. --->
                <cfset courseDetails.error = "Course not found.">
            </cfif>

            <cfreturn courseDetails>

            <cfcatch type="database">
                <!--- Return an error message if there is a database error. --->
                <cfset courseDetails.error = "Error retrieving course: #cfcatch.message#">
                <cfreturn courseDetails>
            </cfcatch>

            <cfcatch type="any">
                <!--- Return a generic error message for other issues. --->
                <cfset courseDetails.error = "An unexpected error occurred: #cfcatch.message#">
                <cfreturn courseDetails>
            </cfcatch>
        </cftry>
    </cffunction>

    <!--- Method to List all Courses --->
    <cffunction name="listAllCourses" access="remote" returntype="query" output="false">
        <!--- Query to retrieve all courses --->
        <cfquery datasource="studentmgmtdb" name="getAllCourses">
            SELECT course_id, course_name, description, created_on, updated_on
            FROM public.courses
            ORDER BY course_name
        </cfquery>

        <!--- Return the query result --->
        <cfreturn getAllCourses>
    </cffunction>

</cfcomponent>

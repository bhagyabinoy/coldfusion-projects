<cfcomponent>
<cffunction name="markAttendanceForCourse" access="remote" returntype="boolean">
    <cfargument name="courseId" type="numeric" required="true">
    <cfargument name="attendanceData" type="array" required="true">
    <cfargument name="attendanceDate" type="date" required="true">

    <!--- Query to get enrollments by course --->
    <cfquery name="enrollments" datasource="studentmgmtdb">
        SELECT e.student_id, e.enrollment_id
        FROM enrollments e
        WHERE e.course_id = <cfqueryparam value="#arguments.courseId#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!--- Loop through the provided attendance data --->
    <cfloop array="#arguments.attendanceData#" index="entry">
        <!--- Find the enrollment record for the student --->
        <cfset studentId = entry.studentId>
        <cfset status = entry.status>

        <cfset enrollmentId = "">
        <cfloop query="enrollments">
            <cfif enrollments.student_id EQ studentId>
                <cfset enrollmentId = enrollments.enrollment_id>
                <cfbreak>
            </cfif>
        </cfloop>

        <!--- Insert attendance record if enrollment found --->
        <cfif enrollmentId neq "">
            <cfquery datasource="studentmgmtdb">
                INSERT INTO attendance (student_id, enrollment_id, attendance_date, status)
                VALUES (
                    <cfqueryparam value="#studentId#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#enrollmentId#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.attendanceDate#" cfsqltype="cf_sql_date">,
                    <cfqueryparam value="#status#" cfsqltype="cf_sql_varchar">
                )
            </cfquery>
        </cfif>
    </cfloop>

    <!--- Return success --->
    <cfreturn true>
</cffunction>

</cfcomponent>
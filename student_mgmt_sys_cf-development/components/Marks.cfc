<cfcomponent>

    <cffunction name="addMarks" access="remote" returntype="string" output="false">
        <!-- Place cfargument directly inside cffunction -->
        <cfargument name="student_id" type="numeric" required="true" />
        <cfargument name="enrollment_id" type="numeric" required="true" />
        <cfargument name="subject_id" type="numeric" required="true" />
        <cfargument name="marks_obtained" type="numeric" required="true" />

        <cfset var result = "Failure" />

        <cftry>
            <cfquery name="insertMarks" datasource="studentmgmtdb">
                INSERT INTO marks (student_id, enrollment_id, subject_id, marks_obtained)
                VALUES (
                    <cfqueryparam value="#arguments.student_id#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.enrollment_id#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.subject_id#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#arguments.marks_obtained#" cfsqltype="cf_sql_integer">
                )
            </cfquery>
            <cfset result = "Mark added successfully" />
        <cfcatch type="any">
            <cflog file="error" text="Error adding student: #cfcatch.message#">
            <cfset result = "Error: #cfcatch.message#">
        </cfcatch>
        </cftry>

        <cfreturn result />
    </cffunction>


    <!--- Function to return all marks for a student based on exam_id and student_id with subject and exam names --->
    <cffunction name="getStudentMarks" access="remote" returntype="query" output="false">
        <cfargument name="exam_id" type="numeric" required="true" />
        <cfargument name="student_id" type="numeric" required="true" />

        <!--- Query to retrieve marks, subject name, and exam name --->
        <cfquery name="marksQuery" datasource="studentmgmtdb">
            SELECT 
                m.mark_id, 
                m.student_id, 
                m.enrollment_id, 
                s.subject_name, 
                e.exam_name, 
                m.marks_obtained
            FROM 
                marks m
            JOIN 
                subjects s ON m.subject_id = s.subject_id
            JOIN 
                exams e ON m.exam_id = e.exam_id
            WHERE 
                m.exam_id = <cfqueryparam value="#arguments.exam_id#" cfsqltype="cf_sql_integer">
            AND 
                m.student_id = <cfqueryparam value="#arguments.student_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <!--- Return the result query --->
        <cfreturn marksQuery />
    </cffunction>


</cfcomponent>


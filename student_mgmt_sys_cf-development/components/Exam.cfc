<cfcomponent>
    <cffunction name="addExam" access="remote" returntype="struct">
        <cfargument name="exam_name" type="string" required="true">
        <cfargument name="description" type="string" required="false" default="">
        <cfargument name="exam_start_date" type="date" required="true">
        <cfargument name="exam_end_date" type="date" required="true">
        
        <cfset var result = structNew()>
        
        <cftry>
            <cfquery datasource="studentmgmtdb" name="insertExam">
                INSERT INTO exams (exam_name, description, exam_start_date, exam_end_date)
                VALUES (
                    <cfqueryparam value="#arguments.exam_name#" cfsqltype="cf_sql_varchar" maxlength="255">,
                    <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_text">,
                    <cfqueryparam value="#arguments.exam_start_date#" cfsqltype="cf_sql_date">,
                    <cfqueryparam value="#arguments.exam_end_date#" cfsqltype="cf_sql_date">
                )
            </cfquery>

            <cfset result.success = true>
            <cfset result.message = "Exam added successfully.">

            <cfcatch>
                <cflog file="error" text="Error adding exam: #cfcatch.message#">
                <cfset result.success = false>
                <cfset result.message = "Error: #cfcatch.message#">
            </cfcatch>
        </cftry>

        <cfreturn result>
    </cffunction>

    <cffunction name="getStudentExams" access="remote" returntype="query" output="false">
        <cfargument name="student_id" type="numeric" required="true" />

        <cfquery name="examQuery" datasource="studentmgmtdb">
            SELECT DISTINCT 
                e.exam_id, 
                e.exam_name
            FROM 
                marks m
            JOIN 
                exams e ON m.exam_id = e.exam_id
            WHERE 
                m.student_id = <cfqueryparam value="#arguments.student_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn examQuery />
    </cffunction>
</cfcomponent>
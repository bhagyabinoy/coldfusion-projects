<cfcomponent displayname="SubjectService">

    <!--- Method to Create a Subject --->
    <cffunction name="createSubject" access="remote" returntype="string" output="false">

        <cfargument name="courseId" type="numeric" required="true">
        <cfargument name="subjectName" type="string" required="true">
        <cfargument name="description" type="string" required="false" default="">
        <cfargument name="maxMarks" type="numeric" required="false" default="100">

        <cfif NOT isNumeric(arguments.courseId) OR arguments.courseId LTE 0>
            <cfreturn "Invalid courseId provided.">
        </cfif>
        
        <cfif len(arguments.subjectName) EQ 0>
            <cfreturn "Subject name cannot be empty.">
        </cfif>
        
        <cfif NOT isNumeric(arguments.maxMarks) OR arguments.maxMarks LTE 0>
            <cfreturn "Invalid maxMarks value. It must be a positive number.">
        </cfif>

        <cfquery datasource="studentmgmtdb" name="insertSubject">
            INSERT INTO public.subjects (course_id, subject_name, description, max_marks)
            VALUES (
                <cfqueryparam value="#arguments.courseId#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#arguments.subjectName#" cfsqltype="cf_sql_varchar" maxlength="255">,
                <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_text">,
                <cfqueryparam value="#arguments.maxMarks#" cfsqltype="cf_sql_integer">
            )
        </cfquery>

        <cfreturn "Subject created successfully!">
    </cffunction>

    <!--- Method to Update a Subject --->
    <cffunction name="updateSubject" access="remote" returntype="string" output="false">

        <cfargument name="subjectId" type="numeric" required="true">
        <cfargument name="courseId" type="numeric" required="false">
        <cfargument name="subjectName" type="string" required="false">
        <cfargument name="description" type="string" required="false" default="">
        <cfargument name="maxMarks" type="numeric" required="false" default="100">

        <cfif NOT isNumeric(arguments.subjectId) OR arguments.subjectId LTE 0>
            <cfreturn "Invalid subjectId provided.">
        </cfif>

        <cfif structKeyExists(arguments, "courseId")>
            <cfif NOT isNumeric(arguments.courseId) OR arguments.courseId LTE 0>
                <cfreturn "Invalid courseId provided.">
            </cfif>

            <cfquery datasource="studentmgmtdb" name="checkCourseExists">
                SELECT 1
                FROM public.courses
                WHERE course_id = <cfqueryparam value="#arguments.courseId#" cfsqltype="cf_sql_integer">
            </cfquery>

            <cfif checkCourseExists.RecordCount EQ 0>
                <cfreturn "The provided courseId does not exist.">
            </cfif>
        </cfif>

        <cfif structKeyExists(arguments, "subjectName") AND len(arguments.subjectName) EQ 0>
            <cfreturn "Subject name cannot be empty.">
        </cfif>

        <cfif structKeyExists(arguments, "maxMarks")>
            <cfif NOT isNumeric(arguments.maxMarks) OR arguments.maxMarks LTE 0>
                <cfreturn "Invalid maxMarks value. It must be a positive number.">
            </cfif>
        </cfif>

        <cfset updateFields = []>
        <cfif structKeyExists(arguments, "courseId")>
            <cfset arrayAppend(updateFields, "course_id = <cfqueryparam value='#arguments.courseId#' cfsqltype='cf_sql_integer'>")>
        </cfif>
        
        <cfif structKeyExists(arguments, "subjectName")>
            <cfset arrayAppend(updateFields, "subject_name = <cfqueryparam value='#arguments.subjectName#' cfsqltype='cf_sql_varchar' maxlength='255'>")>
        </cfif>

        <cfif structKeyExists(arguments, "description")>
            <cfset arrayAppend(updateFields, "description = <cfqueryparam value='#arguments.description#' cfsqltype='cf_sql_text'>")>
        </cfif>

        <cfif structKeyExists(arguments, "maxMarks")>
            <cfset arrayAppend(updateFields, "max_marks = <cfqueryparam value='#arguments.maxMarks#' cfsqltype='cf_sql_integer'>")>
        </cfif>

        <cfif arrayLen(updateFields) GT 0>
            <cfquery datasource="studentmgmtdb" name="updateSubject">
                UPDATE public.subjects
                SET #arrayToList(updateFields, ", ")#
                WHERE subject_id = <cfqueryparam value="#arguments.subjectId#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfreturn "Subject updated successfully!">
        <cfelse>
            <cfreturn "No valid fields provided to update.">
        </cfif>
    </cffunction>

    <!--- Method to Delete a Subject --->
    <cffunction name="deleteSubject" access="remote" returntype="string" output="false">

        <cfargument name="subjectId" type="numeric" required="true">       
        <cfif NOT isNumeric(arguments.subjectId) OR arguments.subjectId LTE 0>
            <cfreturn "Invalid subjectId provided.">
        </cfif>
        <cfquery datasource="studentmgmtdb" name="checkSubjectExists">
            SELECT 1
            FROM public.subjects
            WHERE subject_id = <cfqueryparam value="#arguments.subjectId#" cfsqltype="cf_sql_integer">
        </cfquery>     
        <cfif checkSubjectExists.RecordCount EQ 0>
            <cfreturn "The provided subjectId does not exist.">
        </cfif>
        <cfquery datasource="studentmgmtdb">
            DELETE FROM public.subjects
            WHERE subject_id = <cfqueryparam value="#arguments.subjectId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn "Subject deleted successfully!">
    </cffunction>

    <!--- Method to Retrieve a Subject --->
    <cffunction name="getSubject" access="remote" returntype="struct" output="false">
        <cfargument name="subjectId" type="numeric" required="true">
        
        <cfset var result = {}>
        <cfif NOT isNumeric(arguments.subjectId) OR arguments.subjectId LTE 0>
            <cfset result.status = "error">
            <cfset result.message = "Invalid subjectId provided.">
            <cfreturn result>
        </cfif>

        <cfquery name="getSubject" datasource="studentmgmtdb">
            SELECT * FROM subjects
            WHERE subject_id = <cfqueryparam value="#arguments.subjectId#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfif getSubject.recordCount EQ 0>
            <cfset result.status = "error">
            <cfset result.message = "No subject found for the provided subjectId.">
        <cfelse>
            <cfset result.status = "success">
            <cfset result.data = getSubject>
        </cfif>

        <cfreturn result>
    </cffunction>

    <!--- Method to Retrieve Subjects based on course id --->
    <cffunction name="getSubjectsByCourseId" access="remote" returntype="struct" output="false">
        <cfargument name="courseId" type="numeric" required="true">
        
        <cfset var result = {}>
        
        <cfif NOT isNumeric(arguments.courseId) OR arguments.courseId LTE 0>
            <cfset result.status = "error">
            <cfset result.message = "Invalid courseId provided.">
            <cfreturn result>
        </cfif>
        
        <cfquery name="getCourse" datasource="studentmgmtdb">
            SELECT course_id 
            FROM Courses 
            WHERE course_id = <cfqueryparam value="#arguments.courseId#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfif getCourse.recordCount EQ 0>
            <cfset result.status = "error">
            <cfset result.message = "No course found for the provided courseId.">
        <cfelse>
            <cfquery name="getSubjects" datasource="studentmgmtdb">
                SELECT subject_id, subject_name 
                FROM Subjects 
                WHERE course_id = <cfqueryparam value="#arguments.courseId#" cfsqltype="cf_sql_integer">
            </cfquery>

            <cfif getSubjects.recordCount EQ 0>
                <cfset result.status = "error">
                <cfset result.message = "No subjects found for the provided courseId.">
            <cfelse>
                <cfset result.status = "success">
                <cfset result.data = getSubjects>
            </cfif>
        </cfif>

        <cfreturn result>
    </cffunction>

</cfcomponent>

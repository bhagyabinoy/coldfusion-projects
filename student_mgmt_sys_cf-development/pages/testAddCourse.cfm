<!--- testAddCourse.cfm --->

<cfset courseService = createObject("component", "Courses")>
<cfset result = courseService.addCourse(courseName="Mathematics", description="Basic mathematics course")>

<!--- Output the result --->
<cfoutput>
    #result#
</cfoutput>

<cfif form.userType EQ "teacher">
    <cflocation url="teacherRegistration.cfm">
<cfelseif form.userType EQ "parent">
    <cflocation url="parentRegistration.cfm">
<cfelseif form.userType EQ "student">
    <cflocation url="studentRegistration.cfm">
<cfelse>
    <cflocation url="signup.cfm">
</cfif>

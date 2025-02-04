<cfif structKeyExists(form, "name")>
    <cftry>
        <cfset result = createObject("component", "components.Students").addStudent(
            name = form.name,
            address = form.address,
            phone = form.phone,
            email = form.email,
            date_of_birth = form.date_of_birth,
            gender = form.gender,
            date_of_joining = form.date_of_joining,
            username = form.username,
            password = form.password
        )>
        <cfoutput>
        <div class="message">
            <p>Registration is successful! Please login to continue.</p>
        </div>
        </cfoutput>
        <cfset sleep(5000)>
        <cflocation url="login.cfm">

    <cfcatch type="any">
        <cfoutput>
            <p>Error occurred: #cfcatch.message#</p>
        </cfoutput>
    </cfcatch>
    </cftry>
<cfelse>
    <cfoutput>
        <p>Please fill in the form to register a student.</p>
    </cfoutput>
</cfif>

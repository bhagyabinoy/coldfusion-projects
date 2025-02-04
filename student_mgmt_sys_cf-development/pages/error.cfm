<h1>Error</h1>
<cfoutput>
    The value is: Script Name: #CGI.SCRIPT_NAME#
</cfoutput>
<p>An error occurred while processing your request. Please try again later.</p>
<div class="error-details">
    <h2>Error Details:</h2>
    <cfoutput>
        <p><strong>Message:</strong> #cfcatch.message#</p>
        <p><strong>Type:</strong> #cfcatch.type#</p>
        <p><strong>Template:</strong> #cfcatch.template#</p>
        <p><strong>Line Number:</strong> #cfcatch.line#</p>
    </cfoutput>
</div>
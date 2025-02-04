<cfset application.pageTitle = "Payment Success">
<cfinclude template="../components/header.cfm">
<cfinclude template="../components/styles.cfm">
<cfset session.studentID = studentDetails.student_id>
<cfscript>
    // Get the session_id from the URL
    sessionId = URL.session_id;

    // Check if session_id exists in the URL
    if (!isDefined("URL.session_id")) {
        // Redirect or show an error if session_id is missing
        echo("Missing session ID");
        abort;
    }

    // Stripe secret key
    stripeSecretKey = application.stripeSecretKey;

    // Call Stripe API to get the session details
    cfhttp(
        url = "https://api.stripe.com/v1/checkout/sessions/" & sessionId,
        method = "GET",
        result = "httpResponse"
    ) {
        cfhttpparam(
            type="header",
            name="Authorization",
            value="Bearer " & stripeSecretKey
        );
        cfhttpparam(
            type="header",
            name="Content-Type",
            value="application/x-www-form-urlencoded"
        );
    }

    // Parse the response
    paymentSession = deserializeJSON(httpResponse.fileContent);

    // Check if payment was successful
    if (paymentSession.payment_status EQ "paid") {
        // The part below should be in tag-based CFML, so we leave the cfscript block
</cfscript>

<!--- Tag-based CFML to update the database --->
<cfquery datasource="studentmgmtdb">
    UPDATE fee_management
    SET payment_status = 'paid'
    WHERE student_id = #session.studentID#
</cfquery>

<cfscript>
    } else {
        // Handle cases where the payment wasn't successful
        echo("Payment not completed");
    }
</cfscript>

<div class="container">
    <h1>Payment Successful!</h1>
    <p>Thank you! Your payment was successfully processed.</p>
</div>

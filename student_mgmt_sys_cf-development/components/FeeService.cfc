<cfcomponent displayname="FeeService" hint="Service for managing student fees and processing payments">

    <!--- Method to Add a Fee Record --->
    <cffunction name="addFee" access="remote" returntype="string" output="false">
        <cfargument name="studentId" type="numeric" required="true">
        <cfargument name="courseId" type="numeric" required="true">
        <cfargument name="feeType" type="string" required="true">
        <cfargument name="dueDate" type="date" required="true">

        <cfquery datasource="studentmgmtdb" name="getCourseFee">
            SELECT fee_amount
            FROM public.courses
            WHERE course_id = <cfqueryparam value="#arguments.courseId#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfif getCourseFee.recordCount EQ 0>
            <cfthrow message="No course found with the provided course_id.">
        </cfif>

        <cfquery datasource="studentmgmtdb" name="insertFee">
            INSERT INTO public.fee_management (student_id, fee_type, fee_amount, due_date)
            VALUES (
                <cfqueryparam value="#arguments.studentId#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#arguments.feeType#" cfsqltype="cf_sql_varchar" maxlength="50">,
                <cfqueryparam value="#getCourseFee.fee_amount#" cfsqltype="cf_sql_numeric">,
                <cfqueryparam value="#arguments.dueDate#" cfsqltype="cf_sql_date">
            )
        </cfquery>

        <cfreturn "Fee record added successfully!">
    </cffunction>


    <!--- Method to Process Payment Using Stripe --->
    <cffunction name="processPayment" access="remote" returntype="struct" output="false">
        <cfargument name="studentId" type="numeric" required="true">
        <cfargument name="amount" type="numeric" required="true">
        <cfargument name="currency" type="string" default="usd">
        <cfargument name="description" type="string" default="Student Fee Payment">       
        <cfscript>
            stripeSecretKey = application.stripeSecretKey;

            paymentData = {
                "payment_method_types[0]": "card",
                "line_items[0][price_data][currency]": arguments.currency,
                "line_items[0][price_data][product_data][name]": arguments.description,
                "line_items[0][price_data][unit_amount]": arguments.amount * 100, // Amount in cents
                "line_items[0][quantity]": 1,
                "mode": "payment",
                "success_url": "http://dev.studentmgmtapp.com:8054/pages/paymentSucess.cfm?session_id={CHECKOUT_SESSION_ID}", 
                "cancel_url": "http://dev.studentmgmtapp.com:8054//cancel"
            };

            cfhttp(
                url = "https://api.stripe.com/v1/checkout/sessions",
                method = "POST",
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
                for (var key in paymentData) {
                    cfhttpparam(
                        type="formfield",
                        name=key,
                        value=paymentData[key]
                    );
                }
            }

            paymentResponse = deserializeJSON(httpResponse.fileContent);
            return paymentResponse;
        </cfscript>
    </cffunction>


    <!--- Method to Update Fee Status --->
    <cffunction name="updateFeeStatus" access="private" returntype="string" output="false">
        <cfargument name="studentId" type="numeric" required="true">
        <cfargument name="paymentStatus" type="string" required="true">
        <cfargument name="paymentDate" type="date" required="true">

        <cfquery datasource="studentmgmtdb" name="updateFee">
            UPDATE public.fee_management
            SET payment_status = <cfqueryparam value="#arguments.paymentStatus#" cfsqltype="cf_sql_varchar" maxlength="50">,
                payment_date = <cfqueryparam value="#arguments.paymentDate#" cfsqltype="cf_sql_date">
            WHERE student_id = <cfqueryparam value="#arguments.studentId#" cfsqltype="cf_sql_integer">
              AND payment_status = 'Pending'
        </cfquery>

        <cfreturn "Fee status updated successfully!">
    </cffunction>

</cfcomponent>

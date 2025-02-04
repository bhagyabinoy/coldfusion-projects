1. Store Stripe API Keys Securely

Instead of hardcoding your API keys directly in your code, you should store them securely. You can use environment variables or an external configuration file. 

 Option 1: Environment Variables

1. Set Environment Variables:
   - On your server, set environment variables for your Stripe keys.
   - Example for Linux:
     ```bash
     export STRIPE_SECRET_KEY="sk_test_yourSecretKey"
     export STRIPE_PUBLISHABLE_KEY="pk_test_yourPublishableKey"
     ```

2. Access Environment Variables in ColdFusion:
   - Update your `Application.cfc` to access these variables.

   ```cfscript
   <cfcomponent>
       <cfset this.name = "StudentMgmtApp">
       <cfset this.applicationTimeout = createTimeSpan(0, 0, 30, 0)>
       <cfset this.sessionManagement = true>
       <cfset this.sessionTimeout = createTimeSpan(0, 0, 20, 0)>
       <cfset this.setClientCookies = true>

       <cffunction name="onApplicationStart" returntype="boolean" access="public">
           <cfscript>
               // Application-level initialization code
               application.startTime = now();
               this.datasources["studentmgmtdb"] = {
                   class: "org.postgresql.Driver", 
                   bundleName: "org.postgresql.jdbc", 
                   bundleVersion: "42.6.0",
                   connectionString: "jdbc:postgresql://172.19.0.1:5436/studentmgmtdb",
                   username: "postgres",
                   password: "encrypted:ba1b270f1e7092860c7e0ab46793501daa48523368f75e89f9d05869ca74244f",
                   connectionLimit: -1,
                   liveTimeout: 15, 
                   validate: false,
               };

               // Stripe API Keys
               application.stripeSecretKey = GetSystemVariable("STRIPE_SECRET_KEY");
               application.stripePublishableKey = GetSystemVariable("STRIPE_PUBLISHABLE_KEY");

               this.mappings["/components"] = "/home/spericorn/Documents/sms_cf/components";
               return true;
           </cfscript>
       </cffunction>

       <!-- Other functions remain the same -->

   </cfcomponent>
   ```

 Option 2: External Configuration File

1. Create a Configuration File:
   - Create a configuration file `config/stripe.cfc` or similar.

   ```cfscript
   <cfcomponent>
       <cffunction name="getKeys" returntype="struct" access="public">
           <cfset keys = structNew()>
           <cfset keys.secretKey = "sk_test_yourSecretKey">
           <cfset keys.publishableKey = "pk_test_yourPublishableKey">
           <cfreturn keys>
       </cffunction>
   </cfcomponent>
   ```

2. Include and Access the Configuration File in `Application.cfc`:

   ```cfscript
   <cfcomponent>
       <cfset this.name = "StudentMgmtApp">
       <cfset this.applicationTimeout = createTimeSpan(0, 0, 30, 0)>
       <cfset this.sessionManagement = true>
       <cfset this.sessionTimeout = createTimeSpan(0, 0, 20, 0)>
       <cfset this.setClientCookies = true>

       <cffunction name="onApplicationStart" returntype="boolean" access="public">
           <cfscript>
               // Application-level initialization code
               application.startTime = now();
               this.datasources["studentmgmtdb"] = {
                   class: "org.postgresql.Driver", 
                   bundleName: "org.postgresql.jdbc", 
                   bundleVersion: "42.6.0",
                   connectionString: "jdbc:postgresql://172.19.0.1:5436/studentmgmtdb",
                   username: "postgres",
                   password: "encrypted:ba1b270f1e7092860c7e0ab46793501daa48523368f75e89f9d05869ca74244f",
                   connectionLimit: -1,
                   liveTimeout: 15, 
                   validate: false,
               };

               // Load Stripe API Keys
               stripeConfig = createObject("component", "config/stripe").getKeys();
               application.stripeSecretKey = stripeConfig.secretKey;
               application.stripePublishableKey = stripeConfig.publishableKey;

               this.mappings["/components"] = "/home/spericorn/Documents/sms_cf/components";
               return true;
           </cfscript>
       </cffunction>

       <!-- Other functions remain the same -->

   </cfcomponent>
   ```

 2. Use Stripe API Keys in Your Application

When you need to interact with Stripe, use the keys stored in the `application` scope.

Example Usage in a Function:

```cfscript
<cfcomponent>
    <cffunction name="createCustomer" returntype="struct" access="public">
        <cfscript>
            apiUrl = "https://api.stripe.com/v1/customers";
            apiKey = application.stripeSecretKey;
            customerData = {
                description = "Customer for example@example.com",
                email = "example@example.com"
            };

            httpResponse = http(
                url = apiUrl,
                method = "POST",
                headers = {
                    "Authorization" = "Bearer " & apiKey
                },
                formfields = customerData,
                charset = "utf-8"
            );

            customerResponse = deserializeJSON(httpResponse.fileContent);
            return customerResponse;
        </cfscript>
    </cffunction>
</cfcomponent>
```



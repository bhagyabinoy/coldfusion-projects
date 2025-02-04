<cfcomponent>
    <cfset this.secretKey = "secretkey-schoolmgmt">

    <cffunction name="generateToken" access="public" returntype="string">
        <cfargument name="payload" type="struct" required="true">

        <cfset var header = {
            "alg" = "HS256",
            "typ" = "JWT"
        }>
        <cfset var encodedHeader = toBase64(serializeJSON(header))>
        <cfset var encodedPayload = toBase64(serializeJSON(arguments.payload))>
        <cfset var signature = generateHmacSHA256(encodedHeader & "." & encodedPayload, this.secretKey)>
        <cfset var encodedSignature = toBase64(signature)>
        <cfreturn encodedHeader & "." & encodedPayload & "." & encodedSignature>
    </cffunction>
    
    <cffunction name="verifyToken" access="public" returntype="struct">
        <cfargument name="token" type="string" required="true">
        <cfset var parts = listToArray(arguments.token, ".")>
        <cfset var result = {}>
        <cfif arrayLen(parts) != 3>
            <cfset result.success = false>
            <cfset result.message = "Invalid token format">
            <cfreturn result>
        </cfif>

        <cfset var header = deserializeJSON(toString(base64Decode(parts[1])))>
        <cfset var payload = deserializeJSON(toString(base64Decode(parts[2])))>
        <cfset var signature = generateHmacSHA256(parts[1] & "." & parts[2], this.secretKey)>
        <cfset var encodedSignature = toBase64(signature)>

        <cfif encodedSignature != parts[3]>
            <cfset result.success = false>
            <cfset result.message = "Invalid token signature">
            <cfreturn result>
        </cfif>
        <cfif now() > createDateTime(payload.exp.year, payload.exp.month, payload.exp.day, payload.exp.hour, payload.exp.minute, payload.exp.second)>
            <cfset result.success = false>
            <cfset result.message = "Token expired">
            <cfreturn result>
        </cfif>
        <cfset result.success = true>
        <cfset result.payload = payload>
        <cfreturn result>
    </cffunction>

<cffunction name="generateHmacSHA256" access="private" returntype="binary">
    <cfargument name="data" type="string" required="true">
    <cfargument name="key" type="string" required="true">

    <!--- Convert key to a byte array using charsetEncode --->
    <cfset var keyBytes = charsetEncode(arguments.key, "utf-8")>
    
    <!--- Convert data to byte array --->
    <cfset var dataBytes = charsetEncode(arguments.data, "utf-8")>
    
    <!--- Create SecretKeySpec instance using byte array for key --->
    <cfset var keySpec = createObject("java", "javax.crypto.spec.SecretKeySpec").init(keyBytes.getBytes(), "HmacSHA256")>
    
    <!--- Create Mac instance and initialize it with the key specification --->
    <cfset var mac = createObject("java", "javax.crypto.Mac").getInstance("HmacSHA256")>
    <cfset mac.init(keySpec)>
    
    <!--- Generate HMAC signature --->
    <cfset var signature = mac.doFinal(dataBytes)>
    
    <cfreturn signature>
</cffunction>




</cfcomponent>

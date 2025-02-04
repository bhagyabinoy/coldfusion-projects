<cfset application.pageTitle = "Login">
<cfinclude template="../components/header.cfm">
<cfinclude template="../components/styles.cfm">

<br/>
<center><div class="h1 text-center">Student Management System</div></center>
<div class="wrapper bg-white">
    
    <div class="h4 text-muted text-center pt-2">Enter your login details</div>
    <br/>
    <form class="pt-3" id="loginForm" action="loginAction.cfm" method="POST">
        <div class="form-group py-2">
            <div class="input-field">
                <span class="far fa-user p-2"></span>
                <input type="text" name="username" placeholder="Enter your Username" required class="">
            </div>
        </div>
        <div class="form-group py-1 pb-2">
            <div class="input-field">
                <span class="fas fa-lock p-2"></span>
                <input type="password" name="password" placeholder="Enter your Password" required class="">
            </div>
        </div>
        <div class="remember"> <label class="option text-muted"> Remember me <input type="radio" name="radio"> <span class="checkmark"></span> </label> </div>
        <center>
            <button class="btn btn-block text-center my-3" style="width: 20%; height: 35px;">Log in</button>
        </center>
        <div class="text-center pt-3 text-muted">Not a member? <a href="signup.cfm">Sign up</a></div>
    </form>

    <p id="loginError" style="color: red;">
        <cfoutput>
            <cfif structKeyExists(session, "loginError")>
                Error: #session.loginError#
            </cfif>
        </cfoutput>
    </p>

</div>
<cfinclude template="../components/footer.cfm">

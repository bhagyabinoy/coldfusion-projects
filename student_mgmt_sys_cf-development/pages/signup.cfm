<cfset application.pageTitle = "Sign Up">
<cfinclude template="../components/header.cfm">
<cfinclude template="../components/styles.cfm">

<br/>
<center><div class="h1 text-center">Student Management System</div></center>
<div class="wrapper bg-white">

    <div class="h4 text-muted text-center pt-2">Create an account</div>

    <form class="pt-3" id="signupForm" action="signupRedirect.cfm" method="POST">
        <div class="form-group py-2">
            <p class="text-center text-muted pt-3">Based on your selected role (Teacher, Parent, or Student), you'll be redirected to the respective sign-up page.</p>

            <label class="text-muted">Select User Type</label>
            <div class="input-field">
                <span class="fas fa-user-tag p-2"></span>
                <select name="userType" required class="">
                    <option value="">Select User Type</option>
                    <option value="teacher">Teacher</option>
                    <option value="parent">Parent</option>
                    <option value="student">Student</option>
                </select>
            </div>
        </div>
        <center>
            <button type="submit" class="btn btn-block text-center my-3" style="width: 20%; height: 35px;">Sign Up</button>
        </center>

    </form>
    <div class="text-center pt-3 text-muted">Already have an account? <a href="login.cfm">Log in</a></div>
</div>
<cfinclude template="../components/footer.cfm">
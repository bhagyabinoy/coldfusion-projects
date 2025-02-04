<cfset application.pageTitle = "Student Dashboard">
<cfinclude template="../components/header.cfm">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="../assets/css/dashboard_styles.css">

<cfset studentCFC = createObject("component", "components.Students")>
<cfset enrollmentCFC = createObject("component", "components.Enrollment")>
<cfif structKeyExists(session, "user") AND structKeyExists(session.user, "username")>
    <cfset email = studentCFC.getEmailByUsername(session.user.username)>
<cfelse>
    <cfoutput>Session not initialized. Please log in again.</cfoutput>
    <cfoutput><a href="login.cfm">Login</a></cfoutput>
    <cfabort>
</cfif>

<cfset studentDetails = studentCFC.getStudentDetailsByEmail(email)>
<cfset session.studentID = studentDetails.student_id>
<cfset enrollmentDetails = enrollmentCFC.getEnrollmentDetailsByStudentID(session.studentID)>
<cfset examCFC = createObject("component", "components.Exam")>
<cfset examResults = examCFC.getStudentExams(session.studentID)>

<div class="container mt-5">
    <h1 class="text-center mb-4">Student Management System</h1>
    <cfoutput><p><strong>Welcome, </strong> #studentDetails.name#</p>  </cfoutput>

    <div class="row">
        <div class="col-md-3">
            <div class="list-group">
                <a href="#" class="list-group-item list-group-item-action" onclick="showContent('profile')">Profile</a>
                <a href="#" class="list-group-item list-group-item-action" onclick="showContent('enrollment')">Enrollment</a>
                <a href="#" class="list-group-item list-group-item-action" onclick="showContent('attendance')">Attendance</a>
                <a href="#" class="list-group-item list-group-item-action" onclick="showContent('marks')">Academic Records</a>
                <a href="#" class="list-group-item list-group-item-action" onclick="showContent('guardian')">Guardian Details</a>
                <a href="#" class="list-group-item list-group-item-action" onclick="showContent('fees')">Fees</a>
                <a href="signout.cfm" class="list-group-item list-group-item-action">Sign Out</a>
            </div>
        </div>

        <!-- Content Section -->
        <div class="col-md-9">

            <div id="profile" class="tab-content d-none">
                <cfoutput>
                    <h2>Profile</h2>
                    <p><strong>Name:</strong> #studentDetails.name#</p>
                    <p><strong>Email:</strong> #studentDetails.email#</p>
                    <p><strong>Address:</strong> #studentDetails.address#</p>
                    <p><strong>Phone:</strong> #studentDetails.phone#</p>
                    <p><strong>Date of Birth:</strong> #DateFormat(studentDetails.date_of_birth, "mm/dd/yyyy")#</p>
                    <p><strong>Gender:</strong> 
                        <cfset gender = UCase(studentDetails.gender)>
                        <cfif gender EQ "F">
                            Female
                        <cfelseif gender EQ "M">
                            Male
                        <cfelse>
                            Not Specified
                        </cfif>
                    </p>
                    <p><strong>Date of Joining:</strong> #DateFormat(studentDetails.date_of_joining, "mm/dd/yyyy")#</p>
                </cfoutput>
            </div>

            <div id="enrollment" class="tab-content d-none">
                <h2>Enrollment</h2>
                <cfif structKeyExists(enrollmentDetails, "enrollments") AND arrayLen(enrollmentDetails.enrollments) GT 0>
                <cfoutput>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Course ID</th>
                                <th>Course Name</th>
                                <th>Description</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop array="#enrollmentDetails.enrollments#" index="enrollment">
                                <tr>
                                    <td>#enrollment.course_id#</td>
                                    <td>#enrollment.course_name#</td>
                                    <td>#enrollment.description#</td>
                                    <td>#DateFormat(enrollment.start_date, "mm/dd/yyyy")#</td>
                                    <td>#DateFormat(enrollment.end_date, "mm/dd/yyyy")#</td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                </cfoutput>
            <cfelse>
                <cfoutput>#enrollmentDetails.message#</cfoutput>
            </cfif>
            </div>

            <div id="attendance" class="tab-content d-none">
                <h2>Attendance</h2>
                <p>View your attendance here.</p>
            </div>

            <div id="marks" class="tab-content d-none">
                <h2>Academic Record</h2>
                <cfif examResults.recordCount gt 0>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Exam ID</th>
                                <th>Exam Name</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!--- Loop through each exam and display the results --->
                            <cfoutput query="examResults">
                                <tr>
                                    <td>#examResults.exam_id#</td>
                                    <td>#examResults.exam_name#</td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </table>
                <cfelse>
                    <p>No exam records found for this student.</p>
                </cfif>
            </div>
            
            <div id="guardian" class="tab-content d-none">
                <h2>Guardian Details</h2>
                <p>Your Guardian Details information.</p>
            </div>
            <div id="fees" class="tab-content d-none">
                <h2>Fees</h2>
                <p>Check your Fees here.</p>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // JavaScript to handle tab switching
    function showContent(tab) {
        var tabcontent = document.getElementsByClassName("tab-content");
        for (var i = 0; i < tabcontent.length; i++) {
            tabcontent[i].classList.add('d-none'); // Hide all content
        }
        document.getElementById(tab).classList.remove('d-none'); // Show selected content
    }
    showContent('profile');
</script>

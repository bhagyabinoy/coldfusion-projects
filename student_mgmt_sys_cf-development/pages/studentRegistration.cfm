<cfset application.pageTitle = "Student Registration">
<cfinclude template="../components/header.cfm">
<link rel="stylesheet" type="text/css" href="../assets/css/registration_styles.css">

<div class="container">
    <h2>Register as Student</h2>

    <form action="studentregistrationAction.cfm" method="post">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required>

        <label for="address">Address:</label>
        <input type="text" id="address" name="address" required>

        <label for="phone">Phone:</label>
        <input type="text" id="phone" name="phone" required>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required
               pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" 
               title="Please enter a valid email address (e.g., user@example.com)">

        <label for="date_of_birth">Date of Birth:</label>
        <input type="date" id="date_of_birth" name="date_of_birth" required>

        <label for="gender">Gender:</label>
        <select id="gender" name="gender" required>
            <option value="M">Male</option>
            <option value="F">Female</option>
            <option value="O">Other</option>
        </select>

        <label for="date_of_joining">Date of Joining:</label>
        <input type="date" id="date_of_joining" name="date_of_joining" required>

        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>

        <input type="submit" value="Register Student">
    </form>
    <div class="text-center pt-3 text-muted">Already have an account? <a href="login.cfm">Log in</a></div>
</div>

<cfinclude template="../components/footer.cfm">

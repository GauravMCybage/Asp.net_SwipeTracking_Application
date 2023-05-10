using System;

namespace CybEmptrackersystem
{
    public partial class SwipeForm : System.Web.UI.Page
    {
        // Create a new instance of the database context
        private CybEmpTrackerSystemEntities db = new CybEmpTrackerSystemEntities();

   
        public string EmployeeIdValue
        {
            get { return txtEmployeeID.Value; }
            set { txtEmployeeID.Value = value; }
        }
        public void Page_Load(object sender, EventArgs e)
        {
            // Check if the request is not a postback
            if (!IsPostBack)
            {
                return;
            }

            // Get the selected employee ID from the form data
            if (!int.TryParse(Request.Form["txtEmployeeID"], out int employeeId))
            {
                // Handle the error or display an error message to the user
                return;
            }
    }


        public void swipeInButton_Click(object sender, EventArgs e)
        {
            // Get the current time
            TimeSpan currentTime = DateTime.Now.TimeOfDay;

            // Get the selected employee ID from the dropdown list
            int employeeId = int.Parse(txtEmployeeID.Value);

            // Execute the InsertSwipeIn stored procedure with the EmployeeId and CurrentTime parameters
            db.InsertSwipeIn(null, currentTime, employeeId);
            //ViewBag.Message = "Swipe recorded successfully.";
        }


        public void swipeOutButton_Click(object sender, EventArgs e)
        {
            // Get the current date and time
            TimeSpan currentTime = DateTime.Now.TimeOfDay;


            // Get the selected employee ID from the dropdown list
            int employeeId = int.Parse(txtEmployeeID.Value);

            // Call the InsertOrUpdateSwipeOut method on the db object
            int rowsAffected = db.InsertOrUpdateSwipeOut(DateTime.Now.Date, currentTime, employeeId);

            if (rowsAffected > 0)
            {
                // Show a success message to the user
                myStatusLabel.InnerText = "Swipe out recorded successfully.";
            }
            else
            {
                // Show an error message to the user
                myStatusLabel.InnerText = "Error: Failed to record swipe out.";
            }
        }

        public void completedHoursButton_Click(object sender, EventArgs e)
        {
            // Get the selected employee ID from the dropdown list
            int employeeId = int.Parse(txtEmployeeID.Value);

            // Get the current date
            DateTime currentDate = DateTime.Now.Date;

            // Execute the calculate_total_hours stored procedure with the EmployeeId and currentDate parameters
            int completedMinutes = db.calculate_total_hours(employeeId, currentDate);

            // Convert minutes to hours and minutes
            TimeSpan completedTime = TimeSpan.FromMinutes(completedMinutes);
            string completedHours = string.Format("{0} hours and {1} minutes", (int)completedTime.TotalHours, completedTime.Minutes);

            // Display the completed hours to the user
            myStatusLabel.InnerText = string.Format("Completed hours for today: {0}", completedHours);
        }

    }
}


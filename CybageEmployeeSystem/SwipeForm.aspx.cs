using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CybageEmployeeSystem;

namespace CybageEmployeeSystem
{
    public partial class SwipeForm : System.Web.UI.Page
    {
        private CybEmpSystemEntities1 db;

        protected void Page_Load(object sender, EventArgs e)
        {
            db = new CybEmpSystemEntities1();
        }

        protected void swipeInButton_Click(object sender, EventArgs e)
        {
            int employeeID = int.Parse(txtEmployeeID.Value);
            DateTime swipeDate = DateTime.Now.Date;
            TimeSpan swipeIn = DateTime.Now.TimeOfDay;

            int rowsAffected = db.AddOrUpdateSwipeInData(employeeID, swipeDate, swipeIn);

            if (rowsAffected > 0)
            {
                db.SaveChanges();
                // show success message
            }
            else
            {
                // show error message
            }
        }



        protected void swipeOutButton_Click(object sender, EventArgs e)
        {
            int employeeID = int.Parse(txtEmployeeID.Value);
            DateTime swipeDate = DateTime.Now.Date;
            DateTime swipeOut = DateTime.Now;
            TimeSpan swipeOutTime = swipeOut.TimeOfDay;

            db.AddOrUpdateSwipeOutData(employeeID, swipeDate, swipeOutTime);
            db.SaveChanges();
        }

        protected void completedHoursButton_Click(object sender, EventArgs e)
        {
            db.UpdateTotalHours();
            db.SaveChanges();
        }
    }
}

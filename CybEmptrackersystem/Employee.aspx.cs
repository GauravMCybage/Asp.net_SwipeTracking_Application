using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CybEmptrackersystem
{
    public partial class Employee : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            using (CybEmpTrackerSystemEntities context = new CybEmpTrackerSystemEntities())
            {
                EmployeeDetail employee = new EmployeeDetail()
                {
                    FirstName = txtEmpFName.Text,
                    LastName = txtEmpLName.Text,
                    Age = Convert.ToInt32(txtEmpAge.Text),
                    Gender = rbEmpGender.SelectedValue,
                    Department = ddlEmpDept.Text,
                    IsActive = cbEmpActive.Checked,
                };

                context.EmployeeDetails.Add(employee);
                context.SaveChanges();

                BindGrid();
            }

            ClearInputFields();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearInputFields();
        }

        protected void gvEmployeeDetails_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvEmployeeDetails.EditIndex = e.NewEditIndex;
            BindGrid();
        }

        protected void gvEmployeeDetails_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvEmployeeDetails.EditIndex = -1;
            BindGrid();
        }

        protected void gvEmployeeDetails_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int employeeId = Convert.ToInt32(gvEmployeeDetails.DataKeys[e.RowIndex].Value);

            using (CybEmpTrackerSystemEntities context = new CybEmpTrackerSystemEntities())
            {
                EmployeeDetail employee = context.EmployeeDetails.Find(employeeId);

                if (employee != null)
                {
                    employee.FirstName = e.NewValues["FirstName"].ToString();
                    employee.LastName = e.NewValues["LastName"].ToString();
                    employee.Age = Convert.ToInt32(e.NewValues["Age"]);
                    employee.Gender = e.NewValues["Gender"].ToString();
                    employee.Department = e.NewValues["Department"].ToString();
                    employee.IsActive = Convert.ToBoolean(e.NewValues["IsActive"]);

                    context.SaveChanges();
                    gvEmployeeDetails.EditIndex = -1;
                    BindGrid();
                }
            }
        }

        protected void gvEmployeeDetails_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int employeeId = Convert.ToInt32(gvEmployeeDetails.DataKeys[e.RowIndex].Value);

            using (CybEmpTrackerSystemEntities context = new CybEmpTrackerSystemEntities())
            {
                EmployeeDetail employee = context.EmployeeDetails.Find(employeeId);

                if (employee != null)
                {
                    context.EmployeeDetails.Remove(employee);
                    context.SaveChanges();
                    BindGrid();
                }
            }
        }

        private void BindGrid()
        {
            using (CybEmpTrackerSystemEntities context = new CybEmpTrackerSystemEntities())
            {
                var employees = from emp in context.EmployeeDetails
                                select emp;

                gvEmployeeDetails.DataSource = employees.ToList();
                gvEmployeeDetails.DataBind();
            }
        }

        private void ClearInputFields()
        {
            txtEmpFName.Text = string.Empty;
            txtEmpLName.Text = string.Empty;
            txtEmpAge.Text = string.Empty;
            rbEmpGender.SelectedIndex = 0;
            ddlEmpDept.Text = string.Empty;
            cbEmpActive.Checked = false;
        }

    }
}
  
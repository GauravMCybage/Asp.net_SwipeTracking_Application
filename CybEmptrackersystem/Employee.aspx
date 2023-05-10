<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Employee.aspx.cs" Inherits="CybEmptrackersystem.Employee" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Employee Details Form</title>
</head>
<body>
    <form id = "form1" runat="server">
        <h1>Employee Details Form</h1>
        <div>
            <label for="emp-id">Employee ID:</label>
            <asp:TextBox ID="txtEmpID" runat="server" AutoPostBack="True"></asp:TextBox>
        </div>
        <div>
            <label for="emp-fname" id="txtFirstName">First Name:</label>
            <asp:TextBox ID="txtEmpFName" runat="server"></asp:TextBox>
        </div>
        <div>
            <label for="emp-lname" id="txtLastName">Last Name:</label>
            <asp:TextBox ID="txtEmpLName" runat="server"></asp:TextBox>
        </div>
        <div>
            <label for="emp-age">Age:</label>
            <asp:TextBox ID="txtEmpAge" runat="server"></asp:TextBox>
        </div>
        <div id="ddlGender">
            <label for="emp-gender">Gender:</label>
            <asp:RadioButtonList ID="rbEmpGender" runat="server">
                <asp:ListItem Value="Male">Male</asp:ListItem>
                <asp:ListItem Value="Female">Female</asp:ListItem>
            </asp:RadioButtonList>
        </div>
        <div>
            <label for="emp-dept" id="txtDepartment">Department:</label>
            <asp:DropDownList ID="ddlEmpDept" runat="server">
                <asp:ListItem Value="IT">IT</asp:ListItem>
                <asp:ListItem Value="HR">HR</asp:ListItem>
                <asp:ListItem Value="Sales">Sales</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div>
            <label for="emp-status" id="chkIsActive">Active Status:</label>
            <asp:CheckBox ID="cbEmpActive" runat="server" Text="Active" Checked="true" />
        </div>
        <br />
       <div>
    <asp:GridView ID="gvEmployeeDetails" runat="server" AutoGenerateColumns="false"
        OnRowEditing="gvEmployeeDetails_RowEditing"
        OnRowCancelingEdit="gvEmployeeDetails_RowCancelingEdit"
        OnRowUpdating="gvEmployeeDetails_RowUpdating"
        OnRowDeleting="gvEmployeeDetails_RowDeleting">
        <Columns>
            <asp:BoundField DataField="EmployeeID" HeaderText="Employee ID" ReadOnly="true" />
            <asp:BoundField DataField="FirstName" HeaderText="First Name" />
            <asp:BoundField DataField="LastName" HeaderText="Last Name" />
            <asp:BoundField DataField="Age" HeaderText="Age" />
            <asp:BoundField DataField="Gender" HeaderText="Gender" />
            <asp:BoundField DataField="Department" HeaderText="Department" />
            <asp:TemplateField HeaderText="Active">
                <ItemTemplate>
                    <%# Eval("Active") %>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList ID="ddlActive" runat="server">
                        <asp:ListItem Text="Yes" Value="true"></asp:ListItem>
                        <asp:ListItem Text="No" Value="false"></asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ShowEditButton="true" ShowCancelButton="true" />
            <asp:CommandField ShowDeleteButton="true" />
        </Columns>
    </asp:GridView>
</div>
</form>
</body>
</html>

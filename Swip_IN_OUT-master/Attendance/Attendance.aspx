<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Attendance.aspx.cs" Inherits="Attendance" %>



<%@ Register src="Swipe-Inout.ascx" tagname="Swipe" tagprefix="uc2" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="height: 244px">
            <uc2:Swipe ID="Swipe1" runat="server" />
            <br />
            <br />
            <br />
        </div>
       <div>
       </div>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SwipeForm.aspx.cs" Inherits="CybageEmployeeSystem.SwipeForm" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Swipe Form</title>
    <style>
        /* Styles for the form */
        .form-container {
            width: 400px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f2f2f2;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .form-group {
            margin-bottom: 10px;
        }
        .form-label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
            box-sizing: border-box;
        }
        .form-button {
            display: block;
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        .form-button:hover {
            background-color: #3e8e41;
        }
        .form-status {
            margin-top: 10px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="form-container">
            <h2>Employee Swipe Form</h2>
            <div class="form-group">
                <label for="txtEmployeeID" class="form-label">Employee ID:</label>
               <input type="number" id="txtEmployeeID" name="txtEmployeeID" class="form-input" runat="server" />

            </div>
            <div class="form-group">
                <label for="swipeInButton" class="form-label">Swipe In:</label>
                <button id="swipeInButton" class="form-button" runat="server" onserverclick="swipeInButton_Click">Record Swipe In</button>
            </div>
            <div class="form-group">
                <label for="swipeOutButton" class="form-label">Swipe Out:</label>
                <button id="swipeOutButton" class="form-button" runat="server" onserverclick="swipeOutButton_Click">Record Swipe Out</button>
            </div>
            <div class="form-group">
                <label for="completedHoursButton" class="form-label">Completed Hours:</label>
                <button id="completedHoursButton" class="form-button" runat="server" onserverclick="completedHoursButton_Click">View Completed Hours</button>
            </div>
            <div class="form-group">
                <span id="myStatusLabel" class="form-status" runat="server"></span>
            </div>
        </div>
    </form>
</body>
</html>

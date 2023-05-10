using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CybEmptrackersystem.Tests
{
    [TestClass]
    public class SwipeFormTests
    {
        [TestMethod]
        public void TestPageLoad()
        {
            // Arrange
            var form = new SwipeForm();
            var e = new EventArgs();

            // Act
            form.Page_Load(null, e);

            // Assert
            Assert.IsTrue(!form.IsPostBack, "Page_Load method did not set IsPostBack property to false.");
        }

        [TestMethod]
        public void TestSwipeInButton()
        {
            // Arrange
            var form = new SwipeForm();
            var e = new EventArgs();
            form.txValue = "1";

            // Act
            form.swipeInButton_Click(null, e);

            // Assert
            Assert.AreEqual("Swipe recorded successfully.", form.myStatusLabel.InnerText, "SwipeIn button did not record swipe or set success message.");
        }

        [TestMethod]
        public void TestSwipeOutButton()
        {
            // Arrange
            var form = new SwipeForm();
            var e = new EventArgs();
            form.txtEmployeeID.Value = "1";

            // Act
            form.swipeOutButton_Click(null, e);

            // Assert
            var statusMessage = form.myStatusLabel.InnerText;
            Assert.IsTrue(statusMessage.Contains("Swipe out recorded successfully.") || statusMessage.Contains("Failed to record swipe out."), "SwipeOut button did not record swipe or set success or error message.");
        }

        [TestMethod]
        public void TestCompletedHoursButton()
        {
            // Arrange
            var form = new SwipeForm();
            var e = new EventArgs();
            form.txtEmployeeID.Value = "1";

            // Act
            form.completedHoursButton_Click(null, e);

            // Assert
            Assert.IsTrue(form.myStatusLabel.InnerText.Contains("Completed hours for today: "), "CompletedHours button did not display completed hours message.");
        }
    }
}


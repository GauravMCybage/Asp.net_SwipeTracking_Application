using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BAL.BL_SwipInOutClass;
using Common.SwipInSwipOut1;
using DieDataAccessLayer;

public partial class Swipe_Inout : System.Web.UI.UserControl
{
    BL_SwipInOutClass bL_SwipClassObj = new BL_SwipInOutClass();
    SwipInSwipOut1 swipInSwipOutObj = new SwipInSwipOut1();
    DalSwipInOutClass dal_SwipClassObj = new DalSwipInOutClass();
    public bool IsInsert = false;
    protected void Page_Load(object sender, EventArgs e)
    {
        
        
    }
    protected void Swip_IN_Click(object sender, EventArgs e)
    {
         IsInsert = bL_SwipClassObj.InsertSwip_IN_Data();
    }
    protected void Swip_Out_Click(object sender, EventArgs e)
    {
        IsInsert = bL_SwipClassObj.InsertSwip_Out_Data();
    }

    protected void Completed_Hr_Click(object sender, EventArgs e)
    {
        TotalHr.Text = bL_SwipClassObj.GetTotalHr();
    }

    //public void GetSWipInOutData()
    //{
    //    SwipInSwipOut1 swipobj = new SwipInSwipOut1();
    //    swipobj = bL_SwipClassObj.GetTodaysSWipInOutData();
    //    if (swipobj.Swipe_Out  == null && swipobj.Swipe_In != null)
    //    {
    //        Swip_IN.Enabled = true;
    //    }
    //    else if (swipobj.Swipe_In == null)
    //    {
    //        Swip_IN.Enabled = true;
    //    }
    //    else if (swipobj.Swipe_In != null && swipobj.Swipe_Out == null)
    //    {
    //        Swip_Out.Enabled = true;
    //    }
    //}
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Common.SwipInSwipOut1;
using DieDataAccessLayer;

namespace BAL.BL_SwipInOutClass
{
    public class BL_SwipInOutClass
    {
        DalSwipInOutClass DalSwipClass = new DalSwipInOutClass();
        public bool InsertSwip_IN_Data()
        {
            return DalSwipClass.InsertSwipInData();
        }

        public bool InsertSwip_Out_Data()
        {
            return DalSwipClass.InsertSwipOutData();
        }

        public string  GetTotalHr()
        {
            return DalSwipClass.GetTotalCompletedHr();
        }

        public SwipInSwipOut1 GetTodaysSWipInOutData()
        {
            SwipInSwipOut1 swipobj = new SwipInSwipOut1();
            //swipobj = DalSwipClass.GetTodaysAllSWipInOutData();
            return swipobj;
        }

    }
}
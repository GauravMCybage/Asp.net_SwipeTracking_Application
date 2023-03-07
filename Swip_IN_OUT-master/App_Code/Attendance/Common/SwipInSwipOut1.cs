using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Common.SwipInSwipOut1
{
    public class SwipInSwipOut1
    {
        public SwipInSwipOut1()
        {

        }
        DateTime _SwipeDate, _Swipe_In, _Swipe_Out, _Out_Time, _In_Time;

        public DateTime SwipeDate
        {
            get { return _SwipeDate; }
            set { _SwipeDate = value; }
        }

        public DateTime Swipe_In
        {
            get { return _Swipe_In; }
            set { _Swipe_In = value; }
        }

        public DateTime Swipe_Out
        {
            get { return _Swipe_Out; }
            set { _Swipe_Out = value; }
        }

        public DateTime Out_Time
        {
            get { return _Out_Time; }
            set { _Out_Time = value; }
        }
        public DateTime In_Time
        {
            get { return _In_Time; }
            set { _In_Time = value; }
        }

    }
}


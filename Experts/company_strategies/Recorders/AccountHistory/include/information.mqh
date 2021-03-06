//+------------------------------------------------------------------+
//|                                                  information.mqh |
//|                                                      David Yisun |
//|                                              david_yisun@163.com |
//+------------------------------------------------------------------+
#property copyright "David Yisun"
#property link      "david_yisun@163.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+







//---公共函数---
//+------------------------------------------------------------------+
//|公1:时间转换                                                      |
//|说明:将秒数化为分钟或者小时，或者天数,分别为mode= 0,1,2默认为0    |
//+------------------------------------------------------------------+
double SecondsConvert(long seconds,int mode=0)
  {
   double res=0.0;
   switch(mode)
     {
      case 0 :
         res=double(seconds)/60.00000000;
         break;
      case 1:
         res=double(seconds)/(60.00000000*60.00000000);
         break;
      default:
         res=double(seconds)/(60.00000000*60.00000000*24.00000000);
         break;
     }
   return res;
  }
//+------------------------------------------------------------------+
//|函数一:统计每个订单前后相关信息                                   |
//+------------------------------------------------------------------+
//---订单信息结构体
struct OrderInformation
  {
   string            time; //统计数据的时间
   string            AccountNum;//账户编号
   int               Ticket;//订单编号
   string            symbol; //交易品种
   double            TickValue;//波动一个基点变动的价值(单位:美金)
   double            priceopen;//开仓价
   double            priceclose;//平仓价
   double            OC_Spread;//开平仓价差(点数)
   double            Symbol_Spread;//当前品种点差(点数)          
   string            Type;  //下单性质
   double            Profit; //盈亏数额
   string            result; //盈亏状况
   double            lots;  //持仓手数
   double            margin;//以当前价格估计当时占用保证金
   datetime          OpenTime; //开仓时间
   datetime          CloseTime; //平仓时间
   string            Annotation;//订单注释
   double            holdperiodmin; //持仓时间(min)
   double            holdperiodhour;//hour   
   double            holdperiodday;//day
   double            h_price; //最高价
   datetime          h_time; //时间点
   double            h_timelen; //到达时长
   double            l_price; //最低价
   datetime          l_time; //时间点
   double            l_timelen; //到达时长
   string            hl_price_ratio;//盈亏比
   string            sort;//高低点先后顺序
   double            open[];
   double            high[];
   double            low[];
   double            close[];

  };
//---历史订单信息函数（输入x:文件编号）
void RecorderForOrdersHistory(string x)
  {

   string  name=x+"OrdersHistoryStats.csv";
   FileDelete(name);
   if(OrdersHistoryTotal()<2) return;
   int handle=FileOpen(name,FILE_READ|FILE_CSV|FILE_WRITE,',');
   int Openshift=0;                          //开仓点偏移的bar数
   int Closeshift=0;                         //平仓点偏移的bar数

   OrderInformation orderObject[];           //创建订单信息结构体对象
   ArrayResize(orderObject,OrdersHistoryTotal());
   if(handle!=INVALID_HANDLE)
     {
      //---The title of the file     
      //FileWrite(handle,"OrderNumber","OrderType","rusult","OrderProfit","OpenTime","CloseTime","holdperiod","higest","h_time","h_hp","lowest","l_time","l_hp");  //命名
      FileWrite(handle,"记录信息的时间","账户编号","订单编号","订单号","交易品种","单位变动价值(美元)","性质","盈亏","盈亏数额","开仓时间","开仓价","平仓时间","平仓价","差价(点数)","当前点差","手数","占用保证金","订单注释","持仓时间(分钟)","持仓时间(小时)","持仓时间(天)","期间最高价",
                "时间点","到达时间（分钟）","期间最低价","时间点","到达时间（分钟）","盈亏比","先后顺序");
      //---
      for(int i=1;i<OrdersHistoryTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
           {
            orderObject[i].AccountNum=x; //账户编号
            orderObject[i].Ticket=OrderTicket();
            orderObject[i].symbol=OrderSymbol();//交易品种
            orderObject[i].time=TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS);//记录时间
            orderObject[i].priceopen=OrderOpenPrice(); //开仓价
            orderObject[i].priceclose=OrderClosePrice(); //平仓价
            Openshift=iBarShift(OrderSymbol(),PERIOD_M1,OrderOpenTime());  //开仓点（bar点）
            Closeshift=iBarShift(OrderSymbol(),PERIOD_M1,OrderCloseTime()); //平仓点
            orderObject[i].holdperiodmin=SecondsConvert(OrderCloseTime()-OrderOpenTime(),0);  //持仓时长 分钟
            orderObject[i].holdperiodhour=NormalizeDouble(SecondsConvert(OrderCloseTime()-OrderOpenTime(),1),2);  //持仓时长 小时
            orderObject[i].holdperiodday=NormalizeDouble(SecondsConvert(OrderCloseTime()-OrderOpenTime(),2),3);  //持仓时长 天
            orderObject[i].lots=OrderLots(); //持仓量
            orderObject[i].margin=MarketInfo(OrderSymbol(),MODE_MARGINREQUIRED)*OrderLots(); //占用保证金 
            orderObject[i].TickValue=MarketInfo(OrderSymbol(),MODE_TICKVALUE); //一个基点合约变动点差数
            orderObject[i].OC_Spread=(OrderClosePrice()-OrderOpenPrice())/SymbolInfoDouble(OrderSymbol(),SYMBOL_POINT);//价差
            orderObject[i].Symbol_Spread=MarketInfo(OrderSymbol(),MODE_SPREAD); //点差
                                                                                //Print("持仓   ",orderObject[i].holdperiodmin,"分钟");
            //Print("持仓   ",orderObject[i].holdperiodhour,"小时");
            //Print("持仓   ",orderObject[i].holdperiodday,"天");

            switch(OrderType())
              {
               case OP_BUY :
                  orderObject[i].Type="BUY";
                  break;
               case OP_SELL :
                  orderObject[i].Type="SELL";
                  break;
               case OP_BUYLIMIT :
                  orderObject[i].Type="BUYLIMIT";
                  break;
               case OP_BUYSTOP :
                  orderObject[i].Type="BUYSTOP";
                  break;
               case OP_SELLLIMIT :
                  orderObject[i].Type="SELLLIMIT";
                  break;
               default:
                 orderObject[i].Type="SELLSTOP";
                  break;
              }


            orderObject[i].Profit=OrderProfit();   //每单收益 
            if(OrderProfit()>0)
               orderObject[i].result="盈";
            else if(OrderProfit()<0)
               orderObject[i].result="亏";
            else orderObject[i].result="不亏不赚";

            orderObject[i].OpenTime=OrderOpenTime()-(TimeCurrent()-TimeLocal());  //开仓时间
            orderObject[i].CloseTime=OrderCloseTime()-(TimeCurrent()-TimeLocal()); //平仓时间
            orderObject[i].Annotation=OrderComment();//订单注释

            //---copy price in struct
            CopyOpen(OrderSymbol(),PERIOD_M1,Closeshift,Openshift-Closeshift,orderObject[i].open);
            CopyHigh(OrderSymbol(),PERIOD_M1,Closeshift,Openshift-Closeshift,orderObject[i].high);
            CopyLow(OrderSymbol(),PERIOD_M1,Closeshift,Openshift-Closeshift,orderObject[i].low);
            CopyClose(OrderSymbol(),PERIOD_M1,Closeshift,Openshift-Closeshift,orderObject[i].close);

            int h=iHighest(OrderSymbol(),PERIOD_M1,MODE_HIGH,Openshift-Closeshift,Closeshift);  //最高点位置（bar点） 注意 是从close开始 bars数是倒序的
            orderObject[i].h_price=iHigh(OrderSymbol(),PERIOD_M1,h);
            orderObject[i].h_time=iTime(OrderSymbol(),PERIOD_M1,h);                                            //最高点时间
            orderObject[i].h_timelen=SecondsConvert(orderObject[i].h_time-OrderOpenTime(),0);           //最高点到开盘时的时长（bars数）注意h返回的是位置（bar点）
                                                                                                        //Print("bars"+orderObject[i].h_timelen);
            //Print("价格",High[orderObject[i].]);

            int l=iLowest(OrderSymbol(),PERIOD_M1,MODE_LOW,Openshift-Closeshift,Closeshift);
            orderObject[i].l_price= iLow(OrderSymbol(),PERIOD_M1,l);
            orderObject[i].l_time = iTime(OrderSymbol(),PERIOD_M1,l);
            orderObject[i].l_timelen=SecondsConvert(orderObject[i].l_time-OrderOpenTime(),0);
            orderObject[i].hl_price_ratio=DoubleToStr(orderObject[i].h_price-OrderOpenPrice())+":"+DoubleToStr(orderObject[i].l_price-OrderOpenPrice());
            if(orderObject[i].h_timelen < orderObject[i].l_timelen)
               orderObject[i].sort="先高后低";
            else
            if(orderObject[i].h_timelen > orderObject[i].l_timelen)
               orderObject[i].sort="先低后高";
            else
               orderObject[i].sort="同时高低";
            // Print("盈亏比"+orderObject[i].hl_price_ratio);
            //Print("时长"+orderObject[i].l_timelen);

           }


         //---write data in csv file        
         //FileSeek(handle,0,SEEK_END);   
         FileWrite(handle,
                   orderObject[i].time,
                   orderObject[i].AccountNum,
                   orderObject[i].Ticket,
                   i,
                   orderObject[i].symbol,
                   orderObject[i].TickValue,
                   orderObject[i].Type,
                   orderObject[i].result,
                   orderObject[i].Profit,
                   orderObject[i].OpenTime,
                   orderObject[i].priceopen,
                   orderObject[i].CloseTime,
                   orderObject[i].priceclose,
                   orderObject[i].OC_Spread,
                   orderObject[i].Symbol_Spread,
                   orderObject[i].lots,
                   orderObject[i].margin,
                   orderObject[i].Annotation,
                   orderObject[i].holdperiodmin,
                   orderObject[i].holdperiodhour,
                   orderObject[i].holdperiodday,
                   orderObject[i].h_price,
                   orderObject[i].h_time,
                   orderObject[i].h_timelen,
                   orderObject[i].l_price,
                   orderObject[i].l_time,
                   orderObject[i].l_timelen,
                   orderObject[i].hl_price_ratio,
                   orderObject[i].sort);
        }
     }
   else Print("File open failed!");

   FileClose(handle);
  }
//+------------------------------------------------------------------+

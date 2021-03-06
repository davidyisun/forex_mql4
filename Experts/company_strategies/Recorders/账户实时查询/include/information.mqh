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

#include "..\AccountGet.mq4"
//+------------------------------------------------------------------+
//|信息记录结构体                                  |
//+------------------------------------------------------------------+
//---当前持仓---
struct InfoForTrade
  {
   int               Login;                //账号
   int               OrderNum;             //持仓单数
   int               OrderNum_Long;        //多单数量
   int               OrderNum_Short;       //空单数量
   double            Lots;                 //总手数
   double            Margin_Used;          //已用保证金
   double            Margin_Free;          //可用保证金
   double            Profit;               //持仓盈亏
  };
//---历史持仓---  
struct InfoForHistory
  {
   int               Login;                //账号
   int               OrderNum;             //持仓单数
   int               OrderNum_Long;        //多单数量
   int               OrderNum_Short;       //空单数量
   int               OrderNum_Profit;      //盈单数量
   int               OrderNum_Loss;        //亏单数量
   double            Lots;                 //总手数
   double            Profit;               //总盈亏
   double            Margin;               //累计使用保证金
   double            holdperiod_min;       //平均持仓时间(min)
  };
//+------------------------------------------------------------------+
//|函数一:统计当前账户整体情况                                  |
//+------------------------------------------------------------------+
bool RecorderForNow(string x)
  {
   bool res=true;
   string name=x;  //文件名
//---文件是否存在---
   bool FileExit=false;
   if(FileIsExist(name)) FileExit=true;
//---操作文件---
   int handle=FileOpen(name,FILE_READ|FILE_CSV|FILE_WRITE|FILE_COMMON,',');
   if(handle!=INVALID_HANDLE)
     {
      if(FileExit==false)
         FileWrite(handle,
                   "账号",
                   "杠杆(倍)",
                   "账户余额",
                   "账户净值",
                   "交易商名称",
                   "服务器名称");
      FileSeek(handle,0,SEEK_END);
      FileWrite(handle,
                y.login,
                y.leverage,
                y.balance,
                y.equity,
                y.company,
                y.server);
      FileClose(handle);
      return(res);
     }
   else
     {
      res=false;
      Print("Open The File Failed");
      return(res);
     }

   return(res);
  }
//+------------------------------------------------------------------+
//|函数二:统计当前账户持仓情况                                  |
//+------------------------------------------------------------------+
bool RecorderForTrade(string x)
  {
   bool res=true;
   string name=x;  //文件名
//---文件是否存在---
   bool FileExit=false;
   if(FileIsExist(name)) FileExit=true;
   InfoForTrade  info;
//---操作文件---
   int handle=FileOpen(name,FILE_READ|FILE_CSV|FILE_WRITE|FILE_COMMON,',');
   if(handle!=INVALID_HANDLE)
     {
      if(FileExit==false)
         FileWrite(handle,
                   "账号",
                   "持仓单数",
                   "多单",
                   "空单",
                   "总手数",
                   "已用保证金",
                   "可用保证金",
                   "持仓盈亏");
      FileSeek(handle,0,SEEK_END);
      info.Login=y.login;
      info.OrderNum=0;
      info.OrderNum_Long=0;
      info.OrderNum_Short=0;
      info.Lots=0;
      info.Profit=y.profit;
      info.Margin_Free = y.margin_free;
      info.Margin_Used = y.margin;
      for(int i=0;i<OrdersTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
           {
            Print("OrderSelect Failed");
            continue;
           }
         if(OrderType()>1)
           {
            Print("Order Limit or Stop Exit");
            continue;
           }
         info.OrderNum++;
         info.Lots=info.Lots+OrderLots();
         if(OrderType() == OP_BUY) info.OrderNum_Long++;
         if(OrderType() == OP_SELL) info.OrderNum_Short++;
        }
      FileWrite(handle,
                info.Login,
                info.OrderNum,
                info.OrderNum_Long,
                info.OrderNum_Short,
                info.Lots,
                info.Margin_Used,
                info.Margin_Free,
                info.Profit);
      FileClose(handle);
      return(res);
     }
   else
     {
      res=false;
      Print("Open The File Failed");
      return(res);
     }

   return(res);
  }
//+------------------------------------------------------------------+
//|函数三:统计历史账户持仓情况                                  |
//+------------------------------------------------------------------+
bool RecorderForHistory(string x)
  {
   bool res=true;
   string name=x;  //文件名
//---文件是否存在---
   bool FileExit=false;
   if(FileIsExist(name)) FileExit=true;
   InfoForHistory  info;
//---操作文件---
   int handle=FileOpen(name,FILE_READ|FILE_CSV|FILE_WRITE|FILE_COMMON,',');
   if(handle!=INVALID_HANDLE)
     {
      if(FileExit==false)
         FileWrite(handle,
                   "账号",
                   "持仓单数",
                   "多单",
                   "空单",
                   "盈单",
                   "亏单",
                   "总手数",
                   "累计使用保证金",
                   "累计持仓盈亏",
                   "平均持仓时间(min)");
      FileSeek(handle,0,SEEK_END);
      info.Login=y.login;
      info.OrderNum=0;
      info.OrderNum_Long=0;
      info.OrderNum_Short=0;
      info.OrderNum_Profit=0;
      info.OrderNum_Loss=0;
      info.Lots=0;
      info.Profit = 0;
      info.Margin = 0;
      double holdtime=0;

      for(int i=1;i<OrdersHistoryTotal();i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)
           {
            Print("OrderSelect Failed");
            continue;
           }
         if(OrderType()>1)
           {
            Print("Order Limit or Stop Exit");
            continue;
           }
         info.OrderNum++;
         info.Lots=info.Lots+OrderLots();
         info.Profit= info.Profit+OrderProfit();
         info.Margin=MarketInfo(OrderSymbol(),MODE_MARGINREQUIRED)*OrderLots()+info.Margin;
         if(OrderType() == OP_BUY) info.OrderNum_Long++;
         if(OrderType() == OP_SELL) info.OrderNum_Short++;
         if(OrderProfit()>0) info.OrderNum_Profit++;
         if(OrderProfit()<0) info.OrderNum_Loss++;
         holdtime=holdtime+SecondsConvert(OrderCloseTime()-OrderOpenTime(),0);  //持仓时长 分钟               
        }
      info.holdperiod_min=holdtime/info.OrderNum;
      FileWrite(handle,
                info.Login,
                info.OrderNum,
                info.OrderNum_Long,
                info.OrderNum_Short,
                info.OrderNum_Profit,
                info.OrderNum_Loss,
                info.Lots,
                info.Margin,
                info.Profit,
                info.holdperiod_min);
      FileClose(handle);
      return(res);
     }
   else
     {
      res=false;
      Print("Open The File Failed");
      return(res);
     }

   return(res);
  }
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
   return NormalizeDouble(res,2);
  }
//+------------------------------------------------------------------+

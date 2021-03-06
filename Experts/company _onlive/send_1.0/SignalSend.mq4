//+------------------------------------------------------------------+
//|                                                   SignalSend.mq4 |
//|                                                      David Yisun |
//|                                              David_yisun@163.com |
//+------------------------------------------------------------------+
#property copyright "David Yisun"
#property link      "David_yisun@163.com"
#property version   "1.00"
#property strict    
#property description "跟单系统发射端原始版本"



//---连接外部库
#include "Include/record.mqh"





//---基本参数


input string                EaName="";    //ea名称  

string                      FileName_AccountNow;   
string                      FileName_AccountHistory;                  
int                         handle1=0;     //句柄
int                         handle2=0;



//+------------------------------------------------------------------+
//| 初始化EA                                                            |
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetMillisecondTimer(1);   //
      
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
      
  }
//+------------------------------------------------------------------+
//| 事件驱动                                                             |
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  }
//+------------------------------------------------------------------+
//| 时间驱动                                                             |
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   while (true && !IsStopped())
   {  
      Sleep(10);
      //---

      FileName_AccountNow = IntegerToString(AccountNumber())+"AccountNow.csv";
      FileName_AccountHistory = IntegerToString(AccountNumber())+"AccountHistory.csv";
      Recorder_AccountNow(FileName_AccountNow);
      Recorder_AccountHistory(FileName_AccountHistory,1000000);
   }
  
  

   
  }
//+------------------------------------------------------------------+

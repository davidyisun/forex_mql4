//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                                                      David Yisun |
//|                                              david_yisun@163.com |
//+------------------------------------------------------------------+
#property copyright "David Yisun"
#property link      "david_yisun@163.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input double t=123.123;
int OnInit()
  {
//--- create timer
Alert("ok");
   EventSetMillisecondTimer(1);
      
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
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
//Alert("时间:",TimeLocal(),"  资金净值:",AccountEquity());
//Alert(SymbolsTotal(True));
   
  }
//+------------------------------------------------------------------+

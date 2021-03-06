//+------------------------------------------------------------------+
//|                                                TimeCalculate.mq4 |
//|                                                      David Yisun |
//|                                              David_yisun@163.com |
//+------------------------------------------------------------------+
#property copyright "David Yisun"
#property link      "David_yisun@163.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
  double TS = double(TimeLocal()-TimeCurrent())/(60*60);
  Alert("本地时间早于交易服务器时间:",DoubleToStr(TS,3),"小时");
   
  }
//+------------------------------------------------------------------+

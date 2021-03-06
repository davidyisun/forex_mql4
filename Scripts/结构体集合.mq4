//+------------------------------------------------------------------+
//|                                                        结构体集合.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
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

//---账户信息---
struct AccountInformation
  {
   //---string---
   string                              name;                //账户名称
   string                              server;              //服务器名称        
   string                              currency;            //货币类型
   string                              company;             //交易商名称
   //---integer---
   int                                 login;               //账户编号
   ENUM_ACCOUNT_TRADE_MODE             trade_mode;          //账户交易方式：模拟号还是实盘号
   int                                 leverage;            //账户杠杆
   int                                 limit_orders;        //最大限价单下单量
   bool                                trade_allowed;       //账户是否允许交易
   bool                                trade_expert;        //账户是否允许EA交易
   //---double---
   double                              balance;             //当前余额(不算持仓的盈亏)
   double                              profit;              //当前账户收益
   double                              equity;              //当前账户净值
   double                              margin;              //已用保证金
   double                              margin_free;         //可用保证金
   double                              margin_level;        //预付款比例(净值/已用保证金) 
   double                              margin_so_call;      //建仓的最低要求的预付款比例
   double                              margin_so_so;        //爆仓的预付款比例   
  };






void OnStart()
  {
//---
   
  }
//+------------------------------------------------------------------+

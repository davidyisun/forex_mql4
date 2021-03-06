//+------------------------------------------------------------------+
//|                                                       TrackTrader.mqh |
//|                                                      David Yisun |
//|                                              david_yisun@163.com |
//+------------------------------------------------------------------+
#property copyright "David Yisun"
#property link      "david_yisun@163.com"
#property strict

#include "..\SignalReceive.mq4"
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



/*


//+------------------------------------------------------------------+
//| Class TrackTrade.                                                    |
//| 信息记录类                                                           |
//|                                                                  |
//+------------------------------------------------------------------+

class InfoRecorder
  {
protected:
   ENUM_ORDER_TYPE   order_Type;                     //订单类型
   string            order_Symbol;                   //品种
   double            order_OpenPrice;                //建仓价
   bool              order_Reverse;                  //是否反向跟单
   double            order_Lots;                     //手数
   double            order_TakeProfit;               //止盈
   double            order_StopLoss;                 //止损


public:
                     InfoRecorder(void);                    //构造函数
                    ~InfoRecorder(void);                    //析构函数
   bool              InfoInput(string symbol,
                               ENUM_ORDER_TYPE type,
                               double open_price,
                               double takeprofit,
                               double stoploss,
                               double lots,
                               double lots_ratio,
                               bool   is_reverse=false
                               );
  };
//+------------------------------------------------------------------+
//| Constructor 构造函数                                                     |
//+------------------------------------------------------------------+
InfoRecorder::InfoRecorder(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor  析构函数                                                      |
//+------------------------------------------------------------------+
InfoRecorder::~InfoRecorder(void)
  {
  }
//+------------------------------------------------------------------+
//| Information Input  信息录入                                       |
//+------------------------------------------------------------------+
bool InfoRecorder::InfoInput(string symbol,
                             ENUM_ORDER_TYPE type,
                             double open_price,
                             double takeprofit,
                             double stoploss,
                             double lots,
                             double lots_ratio,
                             bool   is_reverse=false
                             )
  {
   bool res=true;
   order_Reverse= is_reverse;
   order_Symbol = symbol;
   order_Lots=lots*lots_ratio;
   if(!order_Reverse)
     {
      order_Type=type;
      order_TakeProfit=takeprofit;
      order_StopLoss=stoploss;
     }
   else
     {
      case

         }

         return(res);

     }
*/

//---操作检查函数集
//+------------------------------------------------------------------+
//| 检查是否变动当前订单(类型,开仓价,止盈,止损)                      |
//+------------------------------------------------------------------+
void Check_Modify(ENUM_ORDER_TYPE t,double o,double tp,double sl)
  {
   if(t<=1)
     {
      if(tp==OrderTakeProfit() && sl==OrderStopLoss())
         return;
      else
      if(!OrderModify(OrderTicket(),o,sl,tp,0,Blue))
        {
         int e=GetLastError();
         Print("Fail Modify Deal",GetLastError());
        }
     }
   else
     {
      if(o==OrderOpenPrice() && tp==OrderTakeProfit() && sl==OrderStopLoss())
        {
         return;
        }
      else
      if(!OrderModify(OrderTicket(),o,sl,tp,0,Blue))
        {
         int e=GetLastError();
         Print("Fail Modify LimDeal",GetLastError());
        }
     }
  }
//+------------------------------------------------------------------+
//| 检查是否已经开过仓                                                   |
//+------------------------------------------------------------------+
bool Check_Opened(string ticket)
  {
   bool res=false;
   for(int i=0;i<OrdersHistoryTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) continue;
        {
         if(OrderMagicNumber()==MAGICNUM)
           {
            if(OrderComment()==ticket)
              {
               res=true;
               if (IsPrintError) Print("This deal has been opened!");
               return(res);
              }

           }
        }
     }
   return(res);
  }
//+------------------------------------------------------------------+
//| 检查是否在有效延迟时间范围内                                     |
//+------------------------------------------------------------------+
bool Check_Time(datetime time,int deviation)
  {
   bool res=true;
   if((time+deviation)<TimeCurrent())
     {
      res=false;
      if (IsPrintError) Print("over time!");
     }

   return(res);
  }
//+------------------------------------------------------------------+
//| 检查是否在有效价格滑点范围内 t:类型  sym:品种  p:报价  de:偏离   |
//+------------------------------------------------------------------+
bool Check_Price(ENUM_ORDER_TYPE t,string sym,double p,double d)
  {
   bool res=true;
   double ASK=SymbolInfoDouble(sym,SYMBOL_ASK);
//Alert(ASK);
   double BID=MarketInfo(sym,MODE_BID);
   double de=d*MarketInfo(sym,MODE_POINT);
   if(t==OP_BUY)
     {
      double upper= ASK+de;
      double down = ASK-de;
      if(p>upper || p<down)
        {
         res=false;
         Print("over price");
         return(res);
        }
     }
   if(t==OP_SELL)
     {
      double upper=BID+de;
      double down=BID-de;
      if(p>upper || p<down)
        {
         res=false;
         Print("over price");
         return(res);
        }
     }

   return(res);
  }
//+------------------------------------------------------------------+
//| 检查是否为有效品种                                               |
//+------------------------------------------------------------------+
bool Check_Symbol(string sym)
  {
   bool res=true;
   return(res);
  }
//+------------------------------------------------------------------+
//| 检查是否为有效下单类型                                           |
//+------------------------------------------------------------------+
bool Check_OrderType(ENUM_ORDER_TYPE t,bool t_lim,bool t_stop)
  {
   bool res=true;
   if(t==2 || t==3)
     {
      if(t_lim)
        {
         res=false;
         if (IsPrintError) Print("Cannot execute limit deal!");
         return(res);
        }
     }
   if(t==4 || t==5)
     {
      if(t_stop)
        {
         res=false;
         if (IsPrintError) Print("Cannot execute stop deal!");
        }
     }

   return(res);
  }
//+------------------------------------------------------------------+
//| 下单函数                                                         |
//+------------------------------------------------------------------+
bool  SendOrder(string sym,
                ENUM_ORDER_TYPE type,
                double lots,
                double price,
                int slippage,
                double sl,
                double tp,
                string comment,
                int magic
                )
  {
   bool RES=false;
   switch(type)
     {
      case OP_BUY : RES=OrderSend(sym,type,lots,
                                  MarketInfo(sym,MODE_ASK),
                                  slippage,sl,tp,comment,
                                  magic,0,clrGreen);
         break;
      case OP_SELL : RES=OrderSend(sym,type,lots,
                                   MarketInfo(sym,MODE_BID),
                                   slippage,sl,tp,comment,
                                   magic,0,clrGreen);
         break;
      default : RES=OrderSend(sym,type,lots,price,
                              slippage,sl,tp,comment,
                              magic,0,clrGreen);
         break;
     }
   return(RES);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//----正反向跟单函数集
//+------------------------------------------------------------------+
//| 下单品种、类型、价格                                             |
//+------------------------------------------------------------------+
void Rev_OrderType(string M_sym,
                   ENUM_ORDER_TYPE M_t,
                   double M_p,
                   string &sym,
                   ENUM_ORDER_TYPE &t,
                   double &p,
                   bool rev)
  {
   string symbol=M_sym;
   sym=symbol;
   if(rev)
     {
      switch(M_t)
        {
         case OP_BUY :
           {
            t=OP_SELL;
            p=MarketInfo(symbol,MODE_BID);
           };
         break;
         case OP_SELL :
           {
            t=OP_BUY;
            p=MarketInfo(symbol,MODE_ASK);
           }
         break;
         case OP_BUYLIMIT :
           {
            t=OP_SELLSTOP;
            p=M_p;
           }
         break;
         case OP_BUYSTOP :
           {
            t=OP_SELLLIMIT;
            p=M_p;
           }
         break;
         case OP_SELLLIMIT :
           {
            t=OP_BUYSTOP;
            p=M_p;
           }
         break;
         default:
           {
            t=OP_BUYLIMIT;
            p=M_p;
           }
         break;
        }
     }
   else
     {
      t = M_t;
      p = M_p;
     }

  }
//+------------------------------------------------------------------+
//| 止盈止损                                                         |
//+------------------------------------------------------------------+
void Rev_TpAndSl(double M_tp,double M_sl,double &tp,double &sl,bool rev)
  {
   if(!rev)
     {
      tp = M_tp;
      sl = M_sl;
     }
   else
     {
      tp = M_sl;
      sl = M_tp;
     }
  }
//+------------------------------------------------------------------+
//| 手数                                                             |
//+------------------------------------------------------------------+
double GetLots(string M_sym,double M_lots,double lot_ratio)
{
double v=M_lots*lot_ratio;
double v_max=SymbolInfoDouble(M_sym,SYMBOL_VOLUME_MAX);
double v_min=SymbolInfoDouble(M_sym,SYMBOL_VOLUME_MIN);
if(v<v_min) v=v_min;
if(v>v_max) v=v_max;
return(v);

}



//---平仓函数集


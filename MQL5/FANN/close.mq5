//+------------------------------------------------------------------+
//|                                                        close.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
#include <Hairabot\Utils.mq5>

double Balance =0;
input double stop = 1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Balance = AccountInfoDouble(ACCOUNT_BALANCE);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   double current_balance = AccountInfoDouble(ACCOUNT_BALANCE);
   
   Print(current_balance);
   
   if(Balance+stop>=current_balance) {
      close(_Symbol);
   }
  }
//+------------------------------------------------------------------+


void close(string symbolName){   

   CTrade trade;

   if(PositionSelectByTicket(getLastTicket(symbolName))){

      trade.PositionClose(PositionGetInteger(POSITION_TICKET));

   }
}
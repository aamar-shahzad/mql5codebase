//+------------------------------------------------------------------+
//|                                                      Dove EA.mq5 |
//|                                                     Copyright :  |
//|                                                                  |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
CTrade trade;
#property copyright "Copyright : "
#property link      ""
#property version   "1.00"
#property strict
#define MA_MAGIC 47578
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input group           "Moving Average Setting"
input int  Ma1period = 13;
input int  Ma2period = 18;
input int  Ma3period = 50;
input int  Ma4period = 100;
input ENUM_APPLIED_PRICE Ma1price = PRICE_CLOSE;
input ENUM_APPLIED_PRICE Ma2price = PRICE_CLOSE;
input ENUM_APPLIED_PRICE Ma3price = PRICE_CLOSE;
input ENUM_APPLIED_PRICE Ma4price = PRICE_CLOSE;
input ENUM_MA_METHOD Ma1method = MODE_EMA;
input ENUM_MA_METHOD Ma2method = MODE_EMA;
input ENUM_MA_METHOD Ma3method = MODE_EMA;
input ENUM_MA_METHOD Ma4method = MODE_EMA;
input group           "MACD Setting"
input int  FastEMA = 12;
input int  SlowEMA = 26;
input int  MacdSMA = 9;
input ENUM_APPLIED_PRICE Macdprice = PRICE_CLOSE;
input group           "Time Frame Setting"
input ENUM_TIMEFRAMES TimeFrame1 = PERIOD_CURRENT;
input ENUM_TIMEFRAMES TimeFrame2 = PERIOD_M5;
input ENUM_TIMEFRAMES TimeFrame3 = PERIOD_H1;
input ENUM_TIMEFRAMES TimeFrame4 = PERIOD_H4;
static datetime time = 0;
int HandelMa11;
int HandelMa12;
int HandelMa13;
int HandelMa14;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int HandelMa21;
int HandelMa22;
int HandelMa23;
int HandelMa24;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int HandelMa31;
int HandelMa32;
int HandelMa33;
int HandelMa34;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int HandelMa41;
int HandelMa42;
int HandelMa43;
int HandelMa44;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int HandelMacd;
double t11buffer[];
double t12buffer[];
double t13buffer[];
double t14buffer[];
double macdbuffer[];
double macdSignalbuffer[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double t21buffer[];
double t22buffer[];
double t23buffer[];
double t24buffer[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double t31buffer[];
double t32buffer[];
double t33buffer[];
double t34buffer[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double t41buffer[];
double t42buffer[];
double t43buffer[];
double t44buffer[];



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   trade.SetExpertMagicNumber(MA_MAGIC);
   HandelMacd = iMACD(Symbol(), 0, FastEMA, SlowEMA, MacdSMA, Macdprice);
   HandelMa11 = iMA(Symbol(), TimeFrame1, Ma1period, 0, Ma1method, Ma1price);
   HandelMa12 = iMA(Symbol(), TimeFrame1, Ma2period, 0, Ma2method, Ma2price);
   HandelMa13 = iMA(Symbol(), TimeFrame1, Ma3period, 0, Ma3method, Ma3price);
   HandelMa14 = iMA(Symbol(), TimeFrame1, Ma4period, 0, Ma4method, Ma4price);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   HandelMa21 = iMA(Symbol(), TimeFrame2, Ma1period, 0, Ma1method, Ma1price);
   HandelMa22 = iMA(Symbol(), TimeFrame2, Ma2period, 0, Ma2method, Ma2price);
   HandelMa23 = iMA(Symbol(), TimeFrame2, Ma3period, 0, Ma3method, Ma3price);
   HandelMa24 = iMA(Symbol(), TimeFrame2, Ma4period, 0, Ma4method, Ma4price);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   HandelMa31 = iMA(Symbol(), TimeFrame3, Ma1period, 0, Ma1method, Ma1price);
   HandelMa32 = iMA(Symbol(), TimeFrame3, Ma2period, 0, Ma2method, Ma2price);
   HandelMa33 = iMA(Symbol(), TimeFrame3, Ma3period, 0, Ma3method, Ma3price);
   HandelMa34 = iMA(Symbol(), TimeFrame3, Ma4period, 0, Ma4method, Ma4price);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   HandelMa41 = iMA(Symbol(), TimeFrame4, Ma1period, 0, Ma1method, Ma1price);
   HandelMa42 = iMA(Symbol(), TimeFrame4, Ma2period, 0, Ma2method, Ma2price);
   HandelMa43 = iMA(Symbol(), TimeFrame4, Ma3period, 0, Ma3method, Ma3price);
   HandelMa44 = iMA(Symbol(), TimeFrame4, Ma4period, 0, Ma4method, Ma4price);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   ArraySetAsSeries(t11buffer, true);
   ArraySetAsSeries(t12buffer, true);
   ArraySetAsSeries(t13buffer, true);
   ArraySetAsSeries(t14buffer, true);
   ArraySetAsSeries(t21buffer, true);
   ArraySetAsSeries(t22buffer, true);
   ArraySetAsSeries(t23buffer, true);
   ArraySetAsSeries(t24buffer, true);
   ArraySetAsSeries(t31buffer, true);
   ArraySetAsSeries(t32buffer, true);
   ArraySetAsSeries(t33buffer, true);
   ArraySetAsSeries(t34buffer, true);
   ArraySetAsSeries(t41buffer, true);
   ArraySetAsSeries(t42buffer, true);
   ArraySetAsSeries(t43buffer, true);
   ArraySetAsSeries(t44buffer, true);
   ArraySetAsSeries(macdbuffer, true);
   ArraySetAsSeries(macdSignalbuffer, true);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   MqlRates PriceInfo[];
   ArraySetAsSeries(PriceInfo, true);
   CopyRates(_Symbol, 0, 0, 3, PriceInfo);
   CopyBuffer(HandelMacd, 0, 0, 4, macdbuffer);
   CopyBuffer(HandelMacd, 1, 0, 4, macdSignalbuffer);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   CopyBuffer(HandelMa11, 1, 0, 4, t11buffer);
   CopyBuffer(HandelMa12, 1, 0, 4, t12buffer);
   CopyBuffer(HandelMa13, 1, 0, 4, t13buffer);
   CopyBuffer(HandelMa14, 1, 0, 4, t14buffer);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   CopyBuffer(HandelMa21, 1, 0, 4, t21buffer);
   CopyBuffer(HandelMa22, 1, 0, 4, t22buffer);
   CopyBuffer(HandelMa23, 1, 0, 4, t23buffer);
   CopyBuffer(HandelMa24, 1, 0, 4, t24buffer);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   CopyBuffer(HandelMa31, 1, 0, 4, t31buffer);
   CopyBuffer(HandelMa32, 1, 0, 4, t32buffer);
   CopyBuffer(HandelMa33, 1, 0, 4, t33buffer);
   CopyBuffer(HandelMa34, 1, 0, 4, t34buffer);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   CopyBuffer(HandelMa41, 1, 0, 4, t41buffer);
   CopyBuffer(HandelMa42, 1, 0, 4, t42buffer);
   CopyBuffer(HandelMa43, 1, 0, 4, t43buffer);
   CopyBuffer(HandelMa44, 1, 0, 4, t44buffer);
   if(time != iTime(Symbol(), PERIOD_CURRENT, 0))
     {
      time = iTime(Symbol(), PERIOD_CURRENT, 0);
      
      
      
      
      
      
      
      
      
      
     }
  }
  
  
  
  
  
  
  
  
  
//+------------------------------------------------------------------+
bool checkCrossAbove(double &arrayFirst[], double &arraySecond[])
  {
   if(arrayFirst[1] > arraySecond[1])
     {
      return (true);
     }
   else
      return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool checkCrossBelow(double &arrayFirst[], double &arraySecond[])
  {
   if(arrayFirst[1] < arraySecond[1])
     {
      return (true);
     }
   else
      return(false);
  }
//+------------------------------------------------------------------+

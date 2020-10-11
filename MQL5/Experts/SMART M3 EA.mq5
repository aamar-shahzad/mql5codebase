//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
CTrade trade;
#include  <TimeSetting/TimeFilter.mqh>
CSignalITF tf;
#property copyright "INTELLECTUAL PROPERTY - Developer plus Requested by Nsoky Khandile"
#property link      "https://www.fiverr.com/aamirshahzad987"
#property version   "3.00"
input group           "Time Filter  Setting"
input string TradeStartTime = "04:00";
input string TradeEndTime = "13:00";
input group           "Moving Average Setting"
input int  Ma1period = 9;
input int  Ma2period = 21;
input int  Ma3period = 50;
input ENUM_APPLIED_PRICE Ma1price = PRICE_CLOSE;
input ENUM_APPLIED_PRICE Ma2price = PRICE_CLOSE;
input ENUM_APPLIED_PRICE Ma3price = PRICE_CLOSE;
input ENUM_MA_METHOD Ma1method = MODE_EMA;
input ENUM_MA_METHOD Ma2method = MODE_EMA;
input ENUM_MA_METHOD Ma3method = MODE_LWMA;
input group           "RSI Setting"
input int Rsiperiod = 10;
input ENUM_APPLIED_PRICE rsiprice = PRICE_CLOSE;
input double rsi_level = 50;
input group           "ADX Setting"
input int adxperiod = 14;
input double adx_level = 20;
input group           "Parabolic Sar Setting"
input double               step = 0.02;
input double               maximum = 0.2;
input group           "Volume  Setting"
input int  shift = 0;
input double volumersilevel = 25;
input ENUM_APPLIED_VOLUME selectVolume = VOLUME_TICK;
input group           "Trailing Stop   Setting"
input bool trailingStopOn = false;
input bool trailingStopOnBuy = false;
input bool trailingStopOnSell = false;
input double tralingPoints = 150;
input double tralingIncrement = 10;

input group           "Order   Setting"

input double lotsize = 0.1;
input double takeprofit = 100;
input double stoploss = 25;
input color buyarrow = clrGreen;
input color sellarrow = clrRed;
input bool sendAlerts = true;
input bool sendNotifiaction = true;
input bool sendEmail = true;
input string emailTitle = "Message from the mt4";
input group           "waddha_attar_explosion indicator   Setting"
input int Fast_MA = 20;       // Period of the fast MACD moving average
input int Slow_MA = 40;       // Period of the slow MACD moving average
input int BBPeriod = 20;      // Bollinger period
input double BBDeviation = 2.0; // Number of Bollinger deviations
input int  Sensetive = 150;
input int  DeadZonePip = 400;
input int  ExplosionPower = 15;
input int  TrendPower = 150;
input bool AlertWindow = false;
input int  AlertCount = 2;
static datetime mytime = 0;
#define MA_MAGIC 47578
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int HandelMa1;
int HandelMa2;
int HandelMa3;
int HandelRsi;
int Handelsar;
int Handeladx;
int Handelwadha;

//+------------------------------------------------------------------+
//|            buffer of all indicator                  |
//+------------------------------------------------------------------+
double ma1buffer[];
double ma2buffer[];
double ma3buffer[];
double rsibuffer[];
double sarbuffer[];
double adxvalbuffer[];
double minDI[];
double plusDI[];
double wadhaMacdbuffer[];
double wadhaDeadPipbuffer[];
int OnInit()
  {
   trade.SetExpertMagicNumber(MA_MAGIC);
   tf.StartTime(TradeStartTime);
   tf.EndTime(TradeEndTime);
   HandelMa1 = iMA(Symbol(), 0, Ma1period, 0, Ma1method, Ma1price);
   HandelMa2 = iMA(Symbol(), 0, Ma2period, 0, Ma2method, Ma2price);
   HandelMa3 = iMA(Symbol(), 0, Ma3period, 0, Ma3method, Ma3price);
   HandelRsi = iRSI(Symbol(), 0, Rsiperiod, rsiprice);
   Handeladx = iADX(Symbol(), 0, adxperiod);
   Handelsar = iSAR(Symbol(), 0, step, maximum);
   Handelwadha = iCustom(Symbol(), PERIOD_CURRENT, "waddah_attar_explosion", Fast_MA, Slow_MA, BBPeriod, BBDeviation, Sensetive, DeadZonePip, ExplosionPower, TrendPower, AlertWindow, AlertCount);
   ArraySetAsSeries(ma1buffer, true);
   ArraySetAsSeries(ma2buffer, true);
   ArraySetAsSeries(ma3buffer, true);
   ArraySetAsSeries(rsibuffer, true);
   ArraySetAsSeries(sarbuffer, true);
   ArraySetAsSeries(adxvalbuffer, true);
   ArraySetAsSeries(minDI, true);
   ArraySetAsSeries(plusDI, true);
   ArraySetAsSeries(wadhaDeadPipbuffer, true);
   ArraySetAsSeries(wadhaMacdbuffer, true);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   IndicatorRelease(HandelMa1);
   IndicatorRelease(HandelMa2);
   IndicatorRelease(HandelMa3);
   IndicatorRelease(HandelRsi);
   IndicatorRelease(Handelsar);
   IndicatorRelease(Handeladx);
   IndicatorRelease(Handelwadha);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double point=NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_POINT), _Digits);
   MqlRates PriceInfo[];
   ArraySetAsSeries(PriceInfo, true);
   CopyRates(_Symbol, 0, 0, 3, PriceInfo);
   CopyBuffer(HandelMa1, 0, 0, 4, ma1buffer);
   CopyBuffer(HandelMa2, 0, 0, 4, ma2buffer);
   CopyBuffer(HandelMa3, 0, 0, 4, ma3buffer);
   CopyBuffer(HandelRsi, 0, 0, 4, rsibuffer);
   CopyBuffer(Handelsar, 0, 0, 4, sarbuffer);
   CopyBuffer(Handeladx, 0, 0, 4, adxvalbuffer);
   CopyBuffer(Handeladx, 1, 0, 4, plusDI);
   CopyBuffer(Handeladx, 2, 0, 4, minDI);
   CopyBuffer(Handelwadha, 0, 0, 4, wadhaMacdbuffer);
   CopyBuffer(Handelwadha, 2, 0, 4, wadhaDeadPipbuffer);
   Comment("Trading OFF ");
   
   if(mytime != iTime(Symbol(), PERIOD_CURRENT, 0))
     {
      mytime = iTime(Symbol(), PERIOD_CURRENT, 0);
      if(tf.IsTradingTime())
        {
         Comment("Trading On ");
         if(
            //+------------------------------------------------------------------+
            //|                      buy condttions                                            |
            //+------------------------------------------------------------------+
            ((ma1buffer[1] < ma2buffer[1] && ma1buffer[2] > ma2buffer[2]) || (ma1buffer[1] > ma2buffer[1] && ma1buffer[2] < ma2buffer[2]))
            &&
            (ma1buffer[1] > ma3buffer[1] && ma2buffer[1] > ma3buffer[1])
            &&
            (MAslope(Ma1period, 2, 1, Ma1method, Ma1price) > 0 && MAslope(Ma2period, 2, 1, Ma2method, Ma2price) > 0)
            &&   
            (PriceInfo[1].low > sarbuffer[1])
            &&
            (wadhaMacdbuffer[1] > wadhaDeadPipbuffer[1])
            &&
            (rsibuffer[1] > rsi_level && rsibuffer[2] > rsi_level)
            &&
            ((adxvalbuffer[1] >= adx_level) || (adxvalbuffer[2] < adxvalbuffer[1]))
         )
           {
            bool flage = trade.Buy(lotsize, _Symbol, Ask, Ask - stoploss * Point(), Ask + takeprofit * Point(), NULL);
            if(flage)
              {
               sendAlertsAll("Buy Order Send of " + _Symbol, sendAlerts, sendEmail, sendNotifiaction, emailTitle);
              }
           }
         //+------------------------------------------------------------------+
         //|         sell condtitions                                                       |
         //+------------------------------------------------------------------+
         if(
            ((ma1buffer[1] > ma2buffer[1] && ma1buffer[2] < ma2buffer[2]) || (ma1buffer[1] < ma2buffer[1] && ma1buffer[2] > ma2buffer[2]))
            &&
            (ma1buffer[1] < ma3buffer[1] && ma2buffer[1] < ma3buffer[1])
            &&
            (PriceInfo[1].low > sarbuffer[1])
            &&
            (wadhaMacdbuffer[1] > wadhaDeadPipbuffer[1])
            &&
            (MAslope(Ma1period, 2, 1, Ma1method, Ma1price) < 0 && MAslope(Ma2period, 2, 1, Ma2method, Ma2price) < 0)
            &&
            (rsibuffer[1] > rsi_level && rsibuffer[2] > rsi_level)
            &&
            ((adxvalbuffer[1] >= adx_level) || (adxvalbuffer[2] < adxvalbuffer[1]))
         )
           {
            bool flage = trade.Sell(lotsize, _Symbol, Bid, Bid + stoploss * Point(), Ask - takeprofit * Point(), NULL);
            if(flage)
              {
               sendAlertsAll("Sell Order Send of " + _Symbol, sendAlerts, sendEmail, sendNotifiaction, emailTitle);
              }
           }
         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
         if(
            //+------------------------------------------------------------------+
            //|                      buy condttions                                            |
            //+------------------------------------------------------------------+
            ((ma1buffer[1] < ma2buffer[1] && ma1buffer[2] > ma2buffer[2]) || (ma1buffer[1] > ma2buffer[1] && ma1buffer[2] < ma2buffer[2]))
            &&
            (ma1buffer[1] < ma3buffer[1] && ma2buffer[1] < ma3buffer[1])
            &&
            (ma3buffer[3] < ma3buffer[2] < ma3buffer[1])
            &&
            (wadhaMacdbuffer[1] > wadhaDeadPipbuffer[1])
            &&
            (PriceInfo[1].close > ma3buffer[1])
            &&
            (PriceInfo[1].low > sarbuffer[1])
            &&
            (rsibuffer[1] > rsi_level && rsibuffer[2] > rsi_level)
            &&
            ((adxvalbuffer[1] >= adx_level) || (adxvalbuffer[2] < adxvalbuffer[1]))
         )
           {
            bool flage = trade.Buy(lotsize, _Symbol, Ask, Ask - stoploss * Point(), Ask + takeprofit * Point(), NULL);
            if(flage)
              {
               sendAlertsAll("Buy Order Send of " + _Symbol, sendAlerts, sendEmail, sendNotifiaction, emailTitle);
              }
           }
         //+------------------------------------------------------------------+
         //|         sell condtitions                                                       |
         //+------------------------------------------------------------------+
         if(
            ((ma1buffer[1] > ma2buffer[1] && ma1buffer[2] < ma2buffer[2]) || (ma1buffer[1] < ma2buffer[1] && ma1buffer[2] > ma2buffer[2]))
            &&
            (ma1buffer[1] > ma3buffer[1] && ma2buffer[1] > ma3buffer[1])
            &&
            (ma3buffer[3] > ma3buffer[2] > ma3buffer[1])
            &&
            (wadhaMacdbuffer[1] > wadhaDeadPipbuffer[1])
            &&
            (PriceInfo[1].close < ma3buffer[1])
            &&
            (PriceInfo[1].low > sarbuffer[1])
            &&
            (rsibuffer[1] > rsi_level && rsibuffer[2] > rsi_level)
            &&
            ((adxvalbuffer[1] >= adx_level) || (adxvalbuffer[2] < adxvalbuffer[1]))
         )
           {
            bool flage = trade.Sell(lotsize, _Symbol, Bid, Bid + stoploss * Point(), Ask - takeprofit * Point(), NULL);
            if(flage)
              {
               sendAlertsAll("Sell Order Send of " + _Symbol, sendAlerts, sendEmail, sendNotifiaction, emailTitle);
              }
           }
         if(trailingStopOn)
           {
            if(trailingStopOnBuy)
              {
               checkTralingStopBuy(Ask, tralingPoints, tralingIncrement);
              }
            if(trailingStopOnSell)
              {
               checkTralingStopSell(Bid, tralingPoints, tralingIncrement);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void sendAlertsAll(string  message, bool alert, bool email, bool notification, string emailtitle)
  {
   if(alert)
     {
      Alert(message);
     }
   if(email)
     {
      SendMail(emailtitle, message);
     }
   if(notification)
     {
      SendNotification(message);
     }
  }




//+------------------------------------------------------------------
void checkTralingStopSell(double price, double points, double diff)
  {
   double      SL = NormalizeDouble(price + points * _Point, _Digits);
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(symbol == Symbol())
        {
         if(PositionGetInteger(POSITION_TYPE) == ORDER_TYPE_SELL)
           {
            ulong ticket = PositionGetTicket(i);
            double currentSt = PositionGetDouble(POSITION_SL);
            double currentTp = PositionGetDouble(POSITION_TP);
            if(currentSt > SL)
              {
               trade.PositionModify(ticket, currentSt - diff * _Point, currentTp);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
void checkTralingStopBuy(double price, double points, double diff)
  {
   double   SL = NormalizeDouble(price - points * _Point, _Digits);
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      string symbol = PositionGetSymbol(i);
      if(symbol == Symbol())
        {
         if(PositionGetInteger(POSITION_TYPE) == ORDER_TYPE_BUY)
           {
            ulong ticket = PositionGetTicket(i);
            double currentSt = PositionGetDouble(POSITION_SL);
            double currentTp = PositionGetDouble(POSITION_TP);
            if(currentSt > SL)
              {
               trade.PositionModify(ticket, currentSt + diff * _Point, currentTp);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
double MAslope(int length = 250, int iFrom = 11, int iTo = 1,
               ENUM_MA_METHOD      mode = MODE_SMA,
               ENUM_APPLIED_PRICE price = PRICE_CLOSE)
  {
   double maFArray[];
   double maTArray[];
   int count = iFrom - iTo;
   ArrayResize(maFArray, count);
   ArrayResize(maTArray, count);
   ArraySetAsSeries(maFArray, true);
   ArraySetAsSeries(maTArray, true);
   int maF = iMA(_Symbol, PERIOD_M1, length, iFrom, mode, price);
   int maT = iMA(_Symbol, PERIOD_M1, length, iTo, mode, price);
   CopyBuffer(maF, 0, 0, count, maFArray);
   CopyBuffer(maT, 0, 0, count, maTArray);
   return (maTArray[0] - maFArray[0]) / count;
  }
//+------------------------------------------------------------------+

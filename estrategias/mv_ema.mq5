//+------------------------------------------------------------------+
//|                                                       prueba.mq5 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

int EMA15_P15_HNDL;
int EMA15_P1_HNDL;
MqlTick last_tick;
double EMA15_P15_Buff[];
double EMA15_P1_Buff[];

int HISTORIAL[];

datetime d;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isNewBar()
  {
   static datetime last_time=0;
   datetime lastbar_time=SeriesInfoInteger(Symbol(),Period(),SERIES_LASTBAR_DATE);
   if(last_time==0)
     {
      //--- set the time and exit
      last_time=lastbar_time;
      return(false);
     }
   if(last_time!=lastbar_time)
     {
      last_time=lastbar_time;
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   EMA15_P15_HNDL=iMA(_Symbol,15,15,0,MODE_EMA,PRICE_CLOSE);
   EMA15_P1_HNDL=iMA(_Symbol,15,1,0,MODE_EMA,PRICE_CLOSE);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   IndicatorRelease(EMA15_P15_HNDL);
   IndicatorRelease(EMA15_P1_HNDL);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   //int i=2;
   double difAnt=0;
   double difAct=0;
   int ArraySise;
   if(isNewBar())
     {
      d=TimeCurrent();
      //Print("Current Time: ",d);
      ArraySetAsSeries(EMA15_P15_Buff,true);
      ArraySetAsSeries(EMA15_P1_Buff,true);
      if(CopyBuffer(EMA15_P15_HNDL,0,0,3,EMA15_P15_Buff)<0 || CopyBuffer(EMA15_P1_HNDL,0,0,3,EMA15_P1_Buff)<0)
        {
         Print("Error copying EMA Values - error number:",GetLastError(),"!!");
         return;
        }
      ArraySise=ArraySize(EMA15_P1_Buff)-1;
      //for(int i=ArraySise;i>0;i--)
      //  {
      //Print("Current EMA1[",i,"]-EMA15[",i,"]: ",EMA15_P1_Buff[i]-EMA15_P15_Buff[i]);
      difAnt = EMA15_P1_Buff[2]-EMA15_P15_Buff[2];
      difAct = EMA15_P1_Buff[1]-EMA15_P15_Buff[1];
      if(difAnt<difAct)
        {
         //linea EMA1 sube
         Print(" EMA1 ascendente");
         if(difAnt<0 && difAct>0)
           {
            Print("Cruce ascendente!");
           }

           }else {
         Print("EMA1 descendente");
         if(difAnt>0 && difAct<0)
           {
            Print("Cruce descendiente!");
           }
        }
      //}
/*
      for(int i=1;i<ArraySize(EMA15_P15_Buff);i++)
        {
         Print("Current EMA15[",i,"]: ",EMA15_P15_Buff[i]);
        }
      for(int i=1;i<ArraySize(EMA15_P1_Buff);i++)
        {
         Print("Current EMA1[",i,"]: ",EMA15_P1_Buff[i]);
        }        
*/
     }
  }
//+------------------------------------------------------------------+

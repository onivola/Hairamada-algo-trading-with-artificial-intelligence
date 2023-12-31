//+------------------------------------------------------------------+
//|                                           BuddyIlanOptimizer.mq5 |
//|                         Copyright 2018, BPASoftware Thai Co. Ltd |
//|                     https://www.mql5.com/en/market/product/28759 |
//+------------------------------------------------------------------+

/*
 * https://docs.microsoft.com/fr-fr/windows/desktop/api/shellapi/nf-shellapi-shellexecutea :
 *
 * If the function succeeds, it returns a value greater than 32. If the function fails, 
 * it returns an error value that indicates the cause of the failure. The return value 
 * is cast as an HINSTANCE for backward compatibility with 16-bit Windows applications. 
 * It is not a true HINSTANCE, however. It can be cast only to an int and compared to 
 * either 32 or the following error codes below.
 */

#import  "shell32.dll"
int ShellExecuteW(int hwnd,string Operation,string
                  File,string Parameters,string Directory,int ShowCmd);
#import

#include <EasyXML\EasyXml.mqh>


input string sOptimiser="";                         // --------------- Optimiser Settings

input string sTerminalTesterPath="C:\\Program Files\\ForexTime MT5";
input string sTerminalTesterDataPath="C:\\Users\\BPA\\AppData\\Roaming\\MetaQuotes\\Terminal\\5405B7A2ED87FFEE2A792204731FD350";

input int InpTesterPeriod=45;                       // Tester Period (days)

input string sBuddyIlan="";                         // --------------- Buddy Ilan Settings

enum _TradingMode { Fixed,Dynamic };

input _TradingMode TradingMode = Dynamic;             // Fixed or Dynamic volume
input double  InpIlanFixedVolume = 0.1;               // Fixed volume size (if set)

input int InpNCurrencies=1;                         // Number of Buddy Ilan instances on this account

input double  LotExponent = 1.4;
input bool    DynamicPips = true;
input int     DefaultPips = 15;

input int Glubina=24;                               // Number of last bars for calculation of volatility
input int DEL=3;

input int TakeProfit = 40.0;                          // Take Profit (Point)
input int Stoploss = 1000.0;                          // Stop Loss (Point)

input bool InpIlanTrailingStop = true;                // Enable Trailing Stop
input int InpIlanDistanceTS = 5;                      // Trailing Stop distance (Point)

input int MaxTrades=10;
input int InpDeviation=10;                          // Max allowed price deviation (Points)

input bool bSTOFilter = true;                         // Dynamic Trend Filter 
input bool bSTOTimeFrameFilter = false;               // Dynamic TimeFrame Filter
input int InpMaxTf = 60;                              // Max TimeFrame



string gVarStop,gVarSL,gVarTP,gVarSTOFilter,gVarSTOTimeFrameFilter;

string str;

int BetterSL = 0.0;
int BetterTP = 0.0;

double BetterProfit=0.0;
double BetterDD=0.0;
bool BetterSTOFilter;
bool BetterSTOTimeFrameFilter;

enum OptimisationType { _SL,_TP,_STO };

bool bOptimisationDone=false;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
/*
    * Global variables
    */

   gVarStop="BuddyIlan."+_Symbol+".Stop";
   gVarSL = "BuddyIlan." + _Symbol + ".SL";
   gVarTP = "BuddyIlan." + _Symbol + ".TP";
   gVarSTOFilter="BuddyIlan."+_Symbol+".STOFilter";
   gVarSTOTimeFrameFilter="BuddyIlan."+_Symbol+".STOTimeFrameFilter";

   EventSetTimer(5);

   Print("TERMINAL_PATH = ",TerminalInfoString(TERMINAL_PATH));
   Print("TERMINAL_DATA_PATH = ",TerminalInfoString(TERMINAL_DATA_PATH));
   Print("TERMINAL_COMMONDATA_PATH = ",TerminalInfoString(TERMINAL_COMMONDATA_PATH));

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
//---

  }
//+------------------------------------------------------------------+
void OnTimer()
  {
   MqlDateTime dt;

   datetime now=TimeLocal(dt);

// On Saturday
   if(dt.day_of_week!=0)
     {
      bOptimisationDone=false;
      return;
     }

// At 9:00 am
   if(dt.hour<7)
      return;

// Already done ?
   if(bOptimisationDone==true)
      return;

// Remove previous "optimise.ini"
   FileDelete("Optimiser\\Optimise.ini");

// Create the EA config file and copy it to \MQL5\Profiles\Test (Tester Instance)
   if(CreateAndCopyParametersFile(true,false,false,false,0,0,bSTOFilter,bSTOTimeFrameFilter)==false)
      return;

// Copy common.ini -> optimise.ini
   if(CopyAndMoveCommonIni()==false)
      return;

// Add [Tester] stanza in optimise.ini - https://www.metatrader5.com/en/terminal/help/start_advanced/start
   if(AddTesterStanza()==false)
      return;

   Print("=======================\nOptimisation SL-1");

// Start first optimisation SL
   StartOptimizer();

// Copying the report file to the working directory
   if(CopyReport()==false)
      return;

// Analyse reports   
   if(LoadResults(_SL)==false)
      return;

   Print("=======================\nOptimisation STO");

// Create parameter file for STO optimization (the 2 parameters will be optimised at the same time) 
   if(CreateAndCopyParametersFile(false,false,true,true,BetterSL,0,bSTOFilter,bSTOTimeFrameFilter)==false)
      return;

// Start optimizer STO
   StartOptimizer();

// Copying the report file to the working directory
   if(CopyReport()==false)
      return;

   if(LoadResults(_STO)==false)
      return;


   Print("=======================\nOptimisation SL-2");

// Create parameter file for second SL optimization (recalculation with new STO parameter values)
   if(CreateAndCopyParametersFile(true,false,false,false,0,0,BetterSTOFilter,BetterSTOTimeFrameFilter)==false)
      return;

// Start optimizer   
   StartOptimizer();

   if(CopyReport()==false)
      return;

   if(LoadResults(_SL)==false)
      return;


   Print("=======================\nOptimisation TP");

// Create parameter file for TP optimization
   if(CreateAndCopyParametersFile(false,true,false,false,BetterSL,0,BetterSTOFilter,BetterSTOTimeFrameFilter)==false)
     {
      Print("Unable to create parametres file");
      return;
     }

// Start optimizer  
   StartOptimizer();

   if(CopyReport()==false)
      return;

   if(LoadResults(_TP)==false)
      return;

/*
    * Conclusion
    */

   PrintFormat("=======================\nSL=%d TP=%d STOFilter=%s STOTimeFrameFilter=%s (Profit=%.2lf DD=%lf)\n=======================",
               BetterSL,BetterTP,(BetterSTOFilter==true)?"true":"false",(BetterSTOTimeFrameFilter==true)?"true":"false",BetterProfit,BetterDD);

/*
    * Set Global variables - The running BuddyIlan EA will read and use these new values
    */

// If the Draw Down found is over 50%, the EA Stop trading
   if(BetterDD>50.0 && GlobalVariableSet(gVarStop,1.0)==false)
     {
      PrintFormat("Error setting Global Variable [%s]",gVarStop);
     }

   if(GlobalVariableSet(gVarSL,BetterSL)==false)
     {
      PrintFormat("Error setting Global Variable [%s]=%d",gVarSL,BetterSL);
     }

   if(GlobalVariableSet(gVarTP,BetterTP)==false)
     {
      PrintFormat("Error setting Global Variable [%s]=%d",gVarTP,BetterTP);
     }

   if(GlobalVariableSet(gVarSTOFilter,(BetterSTOFilter==true)?1.0:0.0)==false)
     {
      PrintFormat("Error setting Global Variable [%s]=%.1lf",gVarSTOFilter,(BetterSTOFilter==true)?1.0:0.0);
     }

   if(GlobalVariableSet(gVarSTOTimeFrameFilter,(BetterSTOTimeFrameFilter==true)?1.0:0.0)==false)
     {
      PrintFormat("Error setting Global Variable [%s]=%.1lf",gVarSTOTimeFrameFilter,(BetterSTOTimeFrameFilter==true)?1.0:0.0);
     }

   bOptimisationDone=true;
  }
//+------------------------------------------------------------------+
void DisplayNodesSL(CEasyXmlNode *Node)
  {
   for(int i=0; i<Node.Children().Total(); i++)
     {
      CEasyXmlNode *ChildNode=Node.Children().At(i);

      if(ChildNode.Children().Total()==0)
        {
         str+=ChildNode.getValue()+",";
        }
      else
        {
         DisplayNodesSL(ChildNode);

         if(Node.getName()=="Table" && ChildNode.getName()=="Row")
           {
            string res[];
            StringSplit(str,',',res);

            // Bypass columns titles
            if(StringCompare(res[0],"Pass",true)!=0)
              {
               double profit=StringToDouble(res[2]);
               int sl=(int) StringToInteger(res[10]);

               PrintFormat("[%s]  Profit=%.2lf StopLoss=%d DD=%s",str,profit,sl,res[8]);

               if(profit>BetterProfit || (profit==BetterProfit && sl<BetterSL))
                 {
                  BetterProfit=profit;
                  BetterSL=sl;
                 }
              }
           }

         if(Node.getName()=="Table")
            str="";
        }
     }
  }
//+------------------------------------------------------------------+
void DisplayNodesTP(CEasyXmlNode *Node)
  {
   for(int i=0; i<Node.Children().Total(); i++)
     {
      CEasyXmlNode *ChildNode=Node.Children().At(i);

      if(ChildNode.Children().Total()==0)
        {
         str+=ChildNode.getValue()+",";
        }
      else
        {
         DisplayNodesTP(ChildNode);

         if(Node.getName()=="Table" && ChildNode.getName()=="Row")
           {
            string res[];
            StringSplit(str,',',res);

            if(StringCompare(res[0],"Pass",true)!=0)
              {
               double profit=StringToDouble(res[2]);
               int tp=(int) StringToInteger(res[10]);
               double dd=StringToDouble(res[8]);

               PrintFormat("[%s]  Profit=%.2lf TakeProfit=%d DD=%lf",str,profit,tp,dd);

               if((profit>BetterProfit || (profit==BetterProfit && tp<BetterTP)) && dd<50.0)
                 {
                  BetterProfit=profit;
                  BetterTP = tp;
                  BetterDD = dd;
                 }
              }
           }

         if(Node.getName()=="Table")
            str="";
        }
     }
  }
//+------------------------------------------------------------------+
void DisplayNodesSTO(CEasyXmlNode *Node)
  {
   for(int i=0; i<Node.Children().Total(); i++)
     {
      CEasyXmlNode *ChildNode=Node.Children().At(i);

      if(ChildNode.Children().Total()==0)
        {
         str+=ChildNode.getValue()+",";
        }
      else
        {
         DisplayNodesSTO(ChildNode);

         if(Node.getName()=="Table" && ChildNode.getName()=="Row")
           {
            string res[];
            StringSplit(str,',',res);

            if(StringCompare(res[0],"Pass",true)!=0)
              {
               double profit=StringToDouble(res[2]);

               PrintFormat("[%s]  Profit=%.2lf %s %s  DD=%s",str,profit,res[10],res[11],res[8]);

               if(profit>BetterProfit) // On ne tient pas compte du DD ici
                 {
                  BetterProfit=profit;
                  BetterSTOFilter=(res[10]=="true")?true:false;
                  BetterSTOTimeFrameFilter=(res[11]=="true")?true:false;
                 }
              }
           }

         if(Node.getName()=="Table")
            str="";
        }
     }
  }
//+------------------------------------------------------------------+
bool CopyAndMoveCommonIni()
  {
   string PathIniFile= sTerminalTesterDataPath+"\\config\\common.ini";
   string PathTester = TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL5\\Files\\Optimiser\\";

   int ret=ShellExecuteW(0,"Open","xcopy","\""+PathIniFile+"\" \""+PathTester+"\" /y","",0);

// wait until the file is copied
   Sleep(2500);
   if(ret<32)
     {
      Print("Failed copying ini file");
      return false;
     }

// We are working now in the sand box, we can use usual MT5 File commands
   string IniFileName="Optimiser\\common.ini";
   string CopyTo="Optimiser\\optimise.ini";

   return FileMove( IniFileName, 0, CopyTo, 0 );
  }
//+------------------------------------------------------------------+
bool CreateAndCopyParametersFile(bool SL,bool TP,bool STOFilter,bool STOTimeFrameFilter,int SLValue,int TPValue,bool STOFilterValue,bool STOTimeFrameFilterValue)
  {
// MQL5\Profiles\Tester
   int filehandle=FileOpen("Optimiser\\BuddyIlanTester.set",FILE_WRITE|FILE_TXT);

   if(filehandle!=INVALID_HANDLE)
     {
      FileWrite(filehandle,
                "_EA_IDENTIFIER=Buddy Ilan\n",
                "_EA_MAGIC_NUMBER=1111||0||1||10||N\n",
                StringFormat("TradingMode=%d||0||0||0||N\n",TradingMode),
                StringFormat("InpIlanFixedVolume=%lf||0.0||0.000000||0.000000||N\n",InpIlanFixedVolume),
                StringFormat("InpNCurrencies=%d||0||1||10||N\n",InpNCurrencies),
                StringFormat("LotExponent=%lf||0.0||0.000000||0.000000||N\n",LotExponent),
                StringFormat("DynamicPips=%s||false||0||true||N\n",(DynamicPips==true)?"true":"false"),
                StringFormat("DefaultPips=%d||0||1||10||N\n",DefaultPips),
                StringFormat("Glubina=%d||0||1||10||N\n",Glubina),
                StringFormat("DEL=%d||0||1||10||N\n",DEL),

                StringFormat("TakeProfit=%d||30||10||70||%s\n",(TPValue==0)?30:TPValue,(TP==true)?"Y":"N"),
                StringFormat("Stoploss=%d||500||250||1500||%s\n",(SLValue==0)?1000:SLValue,(SL==true)?"Y":"N"),

                StringFormat("InpIlanTrailingStop=%s||false||0||true||N\n",(InpIlanTrailingStop==true)?"true":"false"),
                StringFormat("InpIlanDistanceTS=%d||0||1||10||N\n",InpIlanDistanceTS),
                StringFormat("MaxTrades=%d||0||1||10||N\n",MaxTrades),
                StringFormat("InpDeviation=%d||0||1||10||N\n",InpDeviation),

                StringFormat("bSTOFilter=%s||false||0||true||%s\n",(STOFilterValue==true)?"true":"false",(STOFilter==true)?"Y":"N"),
                StringFormat("bSTOTimeFrameFilter=%s||false||0||true||%s\n",(STOTimeFrameFilterValue==true)?"true":"false",(STOTimeFrameFilter==true)?"Y":"N"),
                StringFormat("InpMaxTf=%d||0||1||10||N\n",InpMaxTf));

      FileClose(filehandle);
     }
   else
     {
      Print("Echec de l'opération FileOpen (BuddyIlanTester.set), erreur ",GetLastError());
      return false;
     }

   Sleep(1500);

   string PathTester=TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL5\\Files\\Optimiser\\BuddyIlanTester.set";
   string PathProfile=sTerminalTesterDataPath+"\\MQL5\\Profiles\\Tester\\";

//PrintFormat( "[%s]", PathTester );
//PrintFormat( "-> [%s]", PathProfile );

// copy the ini file into the tester folder 
   int ret=ShellExecuteW(0,"Open","xcopy","\""+PathTester+"\" \""+PathProfile+"\" /y","",0);

// wait until the file is copied
   Sleep(5000);
   if(ret<32)
     {
      Print("Failed copying parameters file");
      return false;
     }

   return true;
  }
//+------------------------------------------------------------------+
bool StartOptimizer()
  {
// Suppression local
   FileDelete("Optimiser\\BuddyIlanReport.xml");

// Suppression dans Instance Optimiser
   string PathReport=sTerminalTesterDataPath+"\\MQL5\\Files\\Reports\\BuddyIlanReport.xml";

   ShellExecuteW(0,"Open","cmd.exe"," /C del "+PathReport,"",0);

   Sleep(2500);

   int start=ShellExecuteW(0,"Open",sTerminalTesterPath+"\\terminal64.exe","/config:"+TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL5\\Files\\Optimiser\\optimise.ini","",0);
   if(start<32)
     {
      Print("Failed starting Tester");
      return false;
     }

   Sleep(15000);

   return true;
  }
//+------------------------------------------------------------------+
bool CopyReport()
  {
   int nTry=0;

/* 
    * Copie du fichier de report dans répertoire de travail (on attend sa génération)
    */

   while(nTry++<500) // Timeout : 2 heures
     {
      string PathReport = sTerminalTesterDataPath + "\\MQL5\\Files\\Reports\\BuddyIlanReport.xml";
      string PathTarget = TerminalInfoString(TERMINAL_DATA_PATH) + "\\MQL5\\Files\\Optimiser\\";

      int ret=ShellExecuteW(0,"Open","xcopy","\""+PathReport+"\" \""+PathTarget+"\" /y","",0);

      if(ret<32)
        {
         PrintFormat("Waiting generation report (%d) ...",nTry);
         Sleep(15000);
        }
      else
        {
         if(FileIsExist("Optimiser\\BuddyIlanReport.xml")==true)
           {
            PrintFormat("Report found (ret=%d) ...",ret);
            Sleep(2500);
            return true;
           }
         else
           {
            PrintFormat("Waiting report (%d) ...",nTry);
            Sleep(15000);
           }
        }
     }

   return false;
  }
//+------------------------------------------------------------------+
bool LoadResults(OptimisationType eType)
  {
/*
    * Réinitialistion variable
    */

   BetterProfit=0.0;

/*
    * Lecture des résultats
    */

   CEasyXml EasyXmlDocument;
   EasyXmlDocument.setDebugging(false);

// MQL5/Files/Reports/   
   if(EasyXmlDocument.loadXmlFromFullPathFile("Optimiser\\BuddyIlanReport.xml")==true)
     {
      str="";

      CEasyXmlNode *RootNode=EasyXmlDocument.getDocumentRoot();

      for(int j=0; j<RootNode.Children().Total(); j++)
        {
         CEasyXmlNode *ChildNode=RootNode.Children().At(j);

         // PrintFormat( "[%s] Children Total=%d", ChildNode.getName(), ChildNode.Children().Total() );

         for(int i=0; i<ChildNode.Children().Total(); i++)
           {
            CEasyXmlNode *cNode=ChildNode.Children().At(i);

            // PrintFormat( "%d/%d [%s]  children=%d", j, i, cNode.getName(), cNode.Children().Total() );

            if(cNode.getName()=="Worksheet")
              {
               switch(eType)
                 {
                  case _SL :

                     DisplayNodesSL(cNode);

                     PrintFormat("-> SL=%d (Profit=%.2lf)",BetterSL,BetterProfit);

                     break;

                  case _TP :

                     DisplayNodesTP(cNode);

                     PrintFormat("-> TP=%d (Profit=%.2lf DD=%lf)",BetterTP,BetterProfit,BetterDD);

                     break;

                  case _STO :

                     DisplayNodesSTO(cNode);

                     PrintFormat("-> STOFilter=%s STOTimeFrameFilter=%s (Profit=%.2lf)",(BetterSTOFilter==true)?"true":"false",(BetterSTOTimeFrameFilter==true)?"true":"false",BetterProfit);

                     break;
                 }

               break;
              }
           }
        }
     }
   else
      PrintFormat("Error found");

   return true;
  }
//+------------------------------------------------------------------+
bool AddTesterStanza()
  {
   int filehandle=FileOpen("Optimiser\\Optimise.ini",FILE_READ|FILE_WRITE|FILE_TXT);

   if(filehandle!=INVALID_HANDLE)
     {
      FileSeek(filehandle,0,SEEK_END);

      FileWrite(filehandle,"[Tester]\n",
                "Expert=BuddyIlan\\BuddyIlan\n",
                "ExpertParameters=BuddyIlanTester.set\n",
                "Symbol="+_Symbol+"\n",
                "Period=M15\n",
                "Login=\n",
                "Model=4\n",
                "ExecutionMode=0\n",
                "Optimization=2\n",
                "OptimizationCriterion=0\n",
                "FromDate="+TimeToString(TimeGMT()-InpTesterPeriod*86400,TIME_DATE)+"\n",
                "ToDate="+TimeToString(TimeGMT(),TIME_DATE)+"\n",
                "ForwardMode=0\n",
                "Report=MQL5\\Files\\Reports\\BuddyIlanReport\n",
                "ReplaceReport=1\n",
                "ShutdownTerminal=1\n",
                "Deposit=10000\n",
                "Currency=EURUSD\n",
                "Leverage=1:100\n",
                "UseLocal=1\n",
                "UseRemote=0\n",
                "UseCloud=0\n",
                "Visual=1\n");

      FileClose(filehandle);
     }
   else
     {
      Print("FileOpen, error ",GetLastError());
      return false;
     }

   return true;
  }
//+------------------------------------------------------------------+

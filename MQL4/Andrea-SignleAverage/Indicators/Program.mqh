//+------------------------------------------------------------------+
//|                                                      Program.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include <EasyAndFastGUI\Controls\WndEvents.mqh>
//+------------------------------------------------------------------+
//| Class for creating an application                                |
//+------------------------------------------------------------------+
class CProgram : public CWndEvents
  {
private:
   //--- Form 1
   CWindow           m_window1;
   //--- Text label table
   CLabelsTable      m_labels_table;
   //---
   int               Average1, Average2, Average3, Average4;
public:
                     CProgram(void);
                    ~CProgram(void);
   //--- Initialization/uninitialization
   void              OnInitEvent(void);
   void              OnDeinitEvent(const int reason);
   //--- Timer
   void              OnTimerEvent(void);
   //---
protected:
   //--- Chart event handler
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //---
public:
   //--- Create an expert panel
   bool              CreateExpertPanel(void);
   void              SetTableData(double StartNowPips, double StartNowPercent, double MinMaxPips, double MinMaxPercent, double MaxMinPips, double MaxMinPercent, double dAvg1, double dAvg2, double dAvg3, double dAvg4);
   void              SetAverageCount(int nAvg1, int nAvg2, int nAvg3, int nAvg4);
   //---
private:
   //--- Form 1
   bool              CreateWindow1(const string text);
   //--- Text label table
#define LABELS_TABLE1_GAP_X   (1)
#define LABELS_TABLE1_GAP_Y   (25)
   bool              CreateLabelsTable(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CProgram::CProgram(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CProgram::~CProgram(void)
  {
  }
//+------------------------------------------------------------------+
//| Initialization                                                   |
//+------------------------------------------------------------------+
void CProgram::OnInitEvent(void)
  {
  }
//+------------------------------------------------------------------+
//| Uninitialization                                                 |
//+------------------------------------------------------------------+
void CProgram::OnDeinitEvent(const int reason)
  {
//--- Removing the interface
   CWndEvents::Destroy();
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CProgram::OnTimerEvent(void)
  {
   CWndEvents::OnTimerEvent();
//--- Updating the second item of the status bar every 500 milliseconds
   static int count=0;
   if(count<500)
     {
      count+=TIMER_STEP_MSC;
      return;
     }
//--- Zero the counter
   count=0;
//--- Populate the table with data
   for(int c=1; c<m_labels_table.ColumnsTotal(); c++)
      for(int r=1; r<m_labels_table.RowsTotal(); r++)
         m_labels_table.SetValue(c,r,StringFormat("%d-%d", c, r));
//--- Update the table
   m_labels_table.UpdateTable();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CProgram::SetTableData(double StartNowPips, double StartNowPercent, double MinMaxPips, double MinMaxPercent, double MaxMinPips, double MaxMinPercent, double dAvg1, double dAvg2, double dAvg3, double dAvg4)
  {
   m_labels_table.SetValue(1, 1, DoubleToStr(StartNowPips, 2));
   m_labels_table.SetValue(2, 1, DoubleToStr(StartNowPercent, 2));

   m_labels_table.SetValue(1, 2, DoubleToStr(MinMaxPips, 2));
   m_labels_table.SetValue(2, 2, DoubleToStr(MinMaxPercent, 2));

   m_labels_table.SetValue(1, 3, DoubleToStr(MaxMinPips, 2));
   m_labels_table.SetValue(2, 3, DoubleToStr(MaxMinPercent, 2));

   m_labels_table.SetValue(1, 4, DoubleToStr(dAvg1, 2));
   m_labels_table.SetValue(1, 5, DoubleToStr(dAvg2, 2));
   m_labels_table.SetValue(1, 6, DoubleToStr(dAvg3, 2));
   m_labels_table.SetValue(1, 7, DoubleToStr(dAvg4, 2));
   
   m_labels_table.UpdateTable();
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CProgram::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Clicking on the menu item event
   if(id==CHARTEVENT_CUSTOM)
     {
      ::Print(__FUNCTION__," > id: ",id,"; lparam: ",lparam,"; dparam: ",dparam,"; sparam: ",sparam);
     }
  }
//+------------------------------------------------------------------+
//| Create an expert panel                                           |
//+------------------------------------------------------------------+
bool CProgram::CreateExpertPanel(void)
  {
//--- Creating form 1 for controls
   if(!CreateWindow1("DAILY VARIATION"))
      return(false);
//--- Creating controls:
//--- Text label table
   if(!CreateLabelsTable())
      return(false);
//--- Redrawing the chart
   m_chart.Redraw();
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates form 1 for controls                                      |
//+------------------------------------------------------------------+
bool CProgram::CreateWindow1(const string caption_text)
  {
//--- Add the window pointer to the window array
   CWndContainer::AddWindow(m_window1);
//--- Coordinates
   int x=(m_window1.X()>0) ? m_window1.X() : 1;
   int y=(m_window1.Y()>0) ? m_window1.Y() : 20;
//--- Properties
   m_window1.Movable(true);
   m_window1.XSize(302);
   m_window1.YSize(280);
   m_window1.WindowBgColor(clrWhiteSmoke);
   m_window1.WindowBorderColor(clrLightSteelBlue);
   m_window1.CaptionBgColor(clrLightSteelBlue);
   m_window1.CaptionBgColorHover(clrLightSteelBlue);
   m_window1.UseRollButton();
//--- Creating the form
   if(!m_window1.CreateWindow(m_chart_id,m_subwin,caption_text,x,y))
      return(false);
//---
   return(true);
  }

//+------------------------------------------------------------------+
//| Create text label table                                          |
//+------------------------------------------------------------------+
bool CProgram::CreateLabelsTable(void)
  {
#define COLUMNS1_TOTAL (3)
#define ROWS1_TOTAL    (8)
//--- Store pointer to the form
   m_labels_table.WindowPointer(m_window1);
//--- Coordinates
   int x=m_window1.X()+LABELS_TABLE1_GAP_X;
   int y=m_window1.Y()+LABELS_TABLE1_GAP_Y;
//--- The number of visible rows and columns
   int visible_columns_total =3;
   int visible_rows_total    =8;
//--- set properties
   m_labels_table.XSize(300);
   m_labels_table.XOffset(50);
   m_labels_table.ColumnXOffset(100);
   m_labels_table.RowYSize(30);
   m_labels_table.FixFirstRow(true);
   m_labels_table.FixFirstColumn(true);
   m_labels_table.TableSize(COLUMNS1_TOTAL,ROWS1_TOTAL);
   m_labels_table.VisibleTableSize(visible_columns_total,visible_rows_total);
//--- Create table
   if(!m_labels_table.CreateLabelsTable(m_chart_id,m_subwin,x,y))
      return(false);
//--- Populate the table:
//    The first cell is empty
   m_labels_table.SetValue(0,0,"-");
//--- Headers for columns
   m_labels_table.SetValue(1,0,"PIPS");
   m_labels_table.SetValue(2,0,"PERCENT(%)");

//--- Headers for rows, text alignment mode - right
   m_labels_table.SetValue(0,1,"START To NOW");
   m_labels_table.SetValue(0,2,"MIN To MAX");
   m_labels_table.SetValue(0,3,"MAX To MIN");

   m_labels_table.SetValue(0,4,StringFormat("AVERAGE1 (%d)", Average1));
   m_labels_table.SetValue(0,5,StringFormat("AVERAGE2 (%d)", Average2));
   m_labels_table.SetValue(0,6,StringFormat("AVERAGE3 (%d)", Average3));
   m_labels_table.SetValue(0,7,StringFormat("AVERAGE4 (%d)", Average4));
//--- Set the color of text in table cells
   for(int r=1; r<m_labels_table.RowsTotal(); r++)
      m_labels_table.TextColor(1,r,clrRed);
   for(int r=1; r<m_labels_table.RowsTotal(); r++)
      m_labels_table.TextColor(2,r,clrGreen);
//--- Update the table
   m_labels_table.UpdateTable();
//--- Add the element pointer to the base
   CWndContainer::AddToElementsArray(0,m_labels_table);
   return(true);
  }
//+------------------------------------------------------------------+
void CProgram::SetAverageCount(int nCount1, int nCount2, int nCount3, int nCount4)
  {
   Average1 = nCount1;
   Average2 = nCount2;
   Average3 = nCount3;
   Average4 = nCount4;
  }
//+------------------------------------------------------------------+

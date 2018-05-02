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
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
  string t="1.csv";
  EquityRecorder(t);
  }
//+------------------------------------------------------------------+

bool EquityRecorder(string filename)
{
bool res=true;
int handle = FileOpen(filename,FILE_WRITE|FILE_CSV); 
if(handle==INVALID_HANDLE) return res;
FileWrite(handle,"goodboy");
FileWrite(handle,"badgirl");
FileClose(handle);


int handle2 = FileOpen(filename,FILE_WRITE|FILE_READ|FILE_CSV); 
if(handle2==INVALID_HANDLE) return res;
Alert("");
//Alert(FileReadString(handle2));
Alert(FileIsEnding(handle2));
Alert(FileTell(handle2));
FileSeek(handle2,0,SEEK_END);
Alert(FileTell(handle2));
Alert(FileIsEnding(handle2));
FileWriteString(handle2,"david","yisun");
Alert(FileTell(handle2));
//FileWrite(handle2,"坏女孩");
//FileWrite(handle2,"1234");
//Alert(FileTell(handle2));
FileClose(handle2);

int handle3 = FileOpen(filename,FILE_WRITE|FILE_READ|FILE_CSV); 
Alert(FileReadString(handle3));
FileClose(handle3); 
return res;

}

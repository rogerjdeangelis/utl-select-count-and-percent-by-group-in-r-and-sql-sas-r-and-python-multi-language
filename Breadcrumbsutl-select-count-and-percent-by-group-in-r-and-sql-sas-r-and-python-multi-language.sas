%let pgm=utl-select-count-and-percent-by-group-in-r-and-sql-sas-r-and-python-multi-language;

%stop_submission;

Select count and percent by group in r and sql sas r and python multi language

  SOLUTIONS

     1 sas sql
     2 r sql
     3 python sql
     4 base r


github
https://tinyurl.com/2bd385ba
https://github.com/rogerjdeangelis/utl-select-count-and-percent-by-group-in-r-and-sql-sas-r-and-python-multi-language

stackoverflow
https://tinyurl.com/ykpfc8zz
https://stackoverflow.com/questions/79215628/how-can-i-fix-this-code-to-create-a-table-of-the-count-and-proportion-for-each-l

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                         |                                                         |                                    */
/*      INPUT              |   PROCESS                                               |              OUTPIT                */
/*                         |                                                         |                                    */
/*                         |                                                         |                                    */
/*  SD1.HAVE total obs=8   |  Calculate count & percent by bin                       |     SAS                            */
/*                         |  for instance                                           |                                    */
/*   CODE    LSK           |                                                         |     ROWNAMES  LSK  N  PERCENT      */
/*                         |  Consider 20-39                                         |                                    */
/*     1       0           |                                                         |         1      1   1   12.5%       */
/*     2      10           |  Obs 3,4,7 are in this range so                         |         2      2   2   25.0%       */
/*     3      20 *         |                                                         |         3      3   3   37.5%       */
/*     4      30 *         |  count = 3                                              |         4      4   2   25.0%       */
/*     5      50           |  total = 8 (number of obs)                              |                                    */
/*     6      15           |                                                         |     R                              */
/*     7      25 *         |  Count Percent                                          |                                    */
/*     8      40           |                                                         |         LSK n proportion           */
/*                         |    3     37.5     100*3/8                               |                                    */
/*                         |                                                         |     1     0 1      12.5%           */
/*                         |---------------------------------------------------------|     1     0 1      12.5%           */
/*    Set of splits.       |                                                         |     2  1-19 2      25.0%           */
/*    We will hardcode     |  SAS PROC SQL                                           |     3 20-39 3      37.5%           */
/*    these splits as the  |  ============                                           |     4   40+ 2      25.0%           */
/*    op did.              |                                                         |                                    */
/*                         |  select                                                 |     Python                         */
/*  BINS                   |       grp                                               |                                    */
/*                         |     ,count(*)                                           |          grp  cnt  percent         */
/*       0                 |     ,100*count(*)/numrows                               |                                    */
/*       1-19              |  from                                                   |     0      0    1     12.5         */
/*       20-39             |     (select                                             |     1   1-19    2     25.0         */
/*       40+               |         count(*) as numrows                             |     2  20-39    3     37.5         */
/*                         |        ,case                                            |     3    40+    2     25.0         */
/*                         |           when lsk between 20 and 39 then '20-39'       |                                    */
/*                         |           when lsk between  1 and 19 then '1-19'        |                                    */
/*                         |           when lsk >= 40             then '40+'         |                                    */
/*                         |           when lsk=0                 then '0'           |                                    */
/*                         |           else 'UNK'                                    |                                    */
/*                         |         end  as grp                                     |                                    */
/*                         |      from                                               |                                    */
/*                         |         sd1.have)                                       |                                    */
/*                         |  group                                                  |                                    */
/*                         |      by grp                                             |                                    */
/*                         |                                                         |                                    */
/*                         |---------------------------------------------------------|                                    */
/*                         |                                                         |                                    */
/*                         |  R AND PYTHON                                           |                                    */
/*                         |  =============                                          |                                    */
/*                         |                                                         |                                    */
/*                         |  with cnt as                                            |                                    */
/*                         |    (select                                              |                                    */
/*                         |       code                                              |                                    */
/*                         |      ,(select count(*) from have) as tot                |                                    */
/*                         |      ,case                                              |                                    */
/*                         |         when lsk=0                 then "0"             |                                    */
/*                         |         when lsk between  1 and 19 then "1-19"          |                                    */
/*                         |         when lsk between 20 and 39 then "20-39"         |                                    */
/*                         |         when lsk >= 40             then "40+"           |                                    */
/*                         |         else "UNK"                                      |                                    */
/*                         |       end  as grp                                       |                                    */
/*                         |    from                                                 |                                    */
/*                         |       have)                                             |                                    */
/*                         |                                                         |                                    */
/*                         |  select                                                 |                                    */
/*                         |    grp                                                  |                                    */
/*                         |   ,count(*) as cnt                                      |                                    */
/*                         |   ,100.0*count(*)/tot as percent                        |                                    */
/*                         |  from                                                   |                                    */
/*                         |    cnt                                                  |                                    */
/*                         |  group                                                  |                                    */
/*                         |    by grp                                               |                                    */
/*                         |                                                         |                                    */
/*                         |---------------------------------------------------------|                                    */
/*                         |                                                         |                                    */
/*                         |  Base R "%.1f%%" ??                                     |                                    */
/*                         |  =======================                                |                                    */
/*                         |                                                         |                                    */
/*                         |  have<-read_sas("d:/sd1/have.sas7bdat")                 |                                    */
/*                         |  want<-have$LSK |>                                      |                                    */
/*                         |    cut(breaks=c(0, 1, 20, 40, Inf),                     |                                    */
/*                         |   labels=c("0", "1-19", "20-39", "40+"),                |                                    */
/*                         |        right=FALSE) |>                                  |                                    */
/*                         |    table() |>                                           |                                    */
/*                         |    as.data.frame() |>                                   |                                    */
/*                         |    transform(i = sprintf("%.1f%%", Freq                 |                                    */
/*                         |     / sum(Freq) * 100)) |>                              |                                    */
/*                         |    setNames(c("LSK", "n", "proportion"))                |                                    */
/*                         |    fn_tosas9x(                                          |                                    */
/*                         |        inp    = want                                    |                                    */
/*                         |       ,outlib ="d:/sd1/"                                |                                    */
/*                         |       ,outdsn ="want"                                   |                                    */
/*                         |       )                                                 |                                    */
/*                         |                                                         |                                    */
/*                         |    proc print data=sd1.want;                            |                                    */
/*                         |    run;quit;                                            |                                    */
/*                         |                                                         |                                    */
/**************************************************************************************************************************/


options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
   input code lsk;
cards4;
1   0
2  10
3  20
4  30
5  50
6  15
7  25
8  40
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  SD1.HAVE total obs=8                                                                                                  */
/*                                                                                                                        */
/*   CODE    LSK                                                                                                          */
/*                                                                                                                        */
/*     1       0                                                                                                          */
/*     2      10                                                                                                          */
/*     3      20                                                                                                          */
/*     4      30                                                                                                          */
/*     5      50                                                                                                          */
/*     6      15                                                                                                          */
/*     7      25                                                                                                          */
/*     8      40                                                                                                          */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                             _
/ |  ___  __ _ ___   ___  __ _| |
| | / __|/ _` / __| / __|/ _` | |
| | \__ \ (_| \__ \ \__ \ (_| | |
|_| |___/\__,_|___/ |___/\__, |_|
                            |_|
*/

proc sql;
  create
      table want as
  select
       grp
     ,count(*)            as count
     ,100*count(*)/total  as percent
  from
     (select
         count(*) as total
        ,case
           when lsk between 20 and 39 then '20-39'
           when lsk between  1 and 19 then '1-19'
           when lsk >= 40             then '40+'
           when lsk=0                 then '0'
           else 'UNK'
         end  as grp
      from
         sd1.have)
  group
      by grp

;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  WANT total obs=4                                                                                                      */
/*                                                                                                                        */
/*    GRP      COUNT    PERCENT                                                                                           */
/*                                                                                                                        */
/*    0          1        12.5                                                                                            */
/*    1-19       2        25.0                                                                                            */
/*    20-39      3        37.5                                                                                            */
/*    40+        2        25.0                                                                                            */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                     _
|___ \   _ __   ___  __ _| |
  __) | | `__| / __|/ _` | |
 / __/  | |    \__ \ (_| | |
|_____| |_|    |___/\__, |_|
                       |_|
*/

%utl_rbeginx;
parmcards4;
library(sqldf)
library(haven)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
have
want <- sqldf("
  with cnt as
    (select
       code
      ,(select count(*) from have) as tot
      ,case
         when lsk=0                 then '0'
         when lsk between  1 and 19 then '1-19'
         when lsk between 20 and 39 then '20-39'
         when lsk >= 40             then '40+'
         else 'UNK'
       end  as grp
    from
       have)
  select
    grp
   ,count(*) as cnt
   ,100.0*count(*)/tot as percent
  from
    cnt
  group
    by grp
    ")
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                      |                                                                                                 */
/*  R                   |  SAS                                                                                            */
/*                      |                                                                                                 */
/*      grp cnt percent |  ROWNAMES    GRP      CNT    PERCENT                                                            */
/*                      |                                                                                                 */
/*  1     0   1    12.5 |      1       0         1       12.5                                                             */
/*  2  1-19   2    25.0 |      2       1-19      2       25.0                                                             */
/*  3 20-39   3    37.5 |      3       20-39     3       37.5                                                             */
/*  4   40+   2    25.0 |      4       40+       2       25.0                                                             */
/*                      |                                                                                                 */
/**************************************************************************************************************************/

/*____               _   _                             _
|___ /   _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
  |_ \  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
 ___) | | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
|____/  | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
        |_|    |___/                                |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete pywant;
run;quit;

%utl_pybeginx;
parmcards4;
exec(open('c:/oto/fn_python.py').read())
have,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat')
print(have)
want=pdsql('''
  with cnt as                                      \
    (select                                        \
       code                                        \
      ,(select count(*) from have) as tot          \
      ,case                                        \
         when lsk=0                 then "0"       \
         when lsk between  1 and 19 then "1-19"    \
         when lsk between 20 and 39 then "20-39"   \
         when lsk >= 40             then "40+"     \
         else "UNK"                                \
       end  as grp                                 \
    from                                           \
       have)                                       \
  select                                           \
    grp                                            \
   ,count(*) as cnt                                \
   ,100.0*count(*)/tot as percent                  \
  from                                             \
    cnt                                            \
  group                                            \
    by grp                                         \
   ''')
print(want)
fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3)
;;;;
%utl_pyendx;

proc print data=sd1.pywant;
run;quit;

/**************************************************************************************************************************/
/*                          |                                                                                             */
/*       grp  cnt  percent  |  GRP      CNT    PERCENT                                                                    */
/*                          |                                                                                             */
/*  0      0    1     12.5  |  0         1       12.5                                                                     */
/*  1   1-19    2     25.0  |  1-19      2       25.0                                                                     */
/*  2  20-39    3     37.5  |  20-39     3       37.5                                                                     */
/*  3    40+    2     25.0  |  40+       2       25.0                                                                     */
/*                          |                                                                                             */
/**************************************************************************************************************************/

/*      _   _     _
 _ __  | |_(_) __| |_   ___   _____ _ __ ___  ___
| `__| | __| |/ _` | | | \ \ / / _ \ `__/ __|/ _ \
| |    | |_| | (_| | |_| |\ V /  __/ |  \__ \  __/
|_|     \__|_|\__,_|\__, | \_/ \___|_|  |___/\___|
                    |___/
*/

%utl_rbeginx;
parmcards4;
library(sqldf)
library(haven)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
want<-have$LSK |>
  cut(breaks=c(0, 1, 20, 40, Inf),
 labels=c("0", "1-19", "20-39", "40+"),
      right=FALSE) |>
  table() |>
  as.data.frame() |>
  transform(i = sprintf("%.1f%%", Freq
   / sum(Freq) * 100)) |>
  setNames(c("LSK", "cnt", "percent"))
  fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
want
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                  |                                                                                     */
/*  R                      SAS      |                                                                                     */
/*                                  |                                                                                     */
/*      LSK cnt percent    ROWNAMES |   LSK    CNT    PERCENT                                                             */
/*                                  |                                                                                     */
/*  1     0   1   12.5%        1    |    1      1      12.5%                                                              */
/*  2  1-19   2   25.0%        2    |    2      2      25.0%                                                              */
/*  3 20-39   3   37.5%        3    |    3      3      37.5%                                                              */
/*  4   40+   2   25.0%        4    |    4      2      25.0%                                                              */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/

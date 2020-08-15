!---------  初期設定  --------------------
OPTION BASE 0
DIM xm(99),xs(99)
!---------  学生番号  --------------------
LET numb$="15417098"    
LET who$="山下 清史"
LET number=VAL(numb$)
!---------  システム関数　----------------
DECLARE EXTERNAL SUB pdnn
DECLARE EXTERNAL SUB plotzz
DECLARE EXTERNAL SUB plotmm
DECLARE EXTERNAL SUB setgraph

!-- 基本論理回路  --------
DECLARE EXTERNAL SUB test    ! CALL test(i,y0,y1,y2,y3,y4,y5)
DECLARE EXTERNAL SUB dff     ! CALL dff(clock,d,qo,qb,xm(*),xs(*))
DECLARE EXTERNAL SUB nand2    ! CALL nand2(out,in1,in2)
DECLARE EXTERNAL SUB nor2     ! CALL nor2(out,in1,in2)
DECLARE EXTERNAL SUB and2    ! CALL and2(out,in1,in2)
DECLARE EXTERNAL SUB or2     ! CALL or2(out,in1,in2)
DECLARE EXTERNAL SUB inv1    ! CALL inv1(out,in)
DECLARE EXTERNAL SUB pmos    ! CALL pmos(d,g,s)
DECLARE EXTERNAL SUB nmos    ! CALL nmos(d,g,s)
DECLARE EXTERNAL SUB mnand2   ! CALL mnand2(out,in1,in2)
DECLARE EXTERNAL SUB mnor2     ! CALL mnor2(out,in1,in2)
DECLARE EXTERNAL SUB minv1   ! CALL minv1(out,in)
DECLARE EXTERNAL SUB mdff


!--------------------------
LET  tslot=37
CALL setgraph(tslot,xm,xs)
!--------  初期設定終了  ------------------------------------------------------
!------------------------------------------------------------------------------
FOR i=0  TO tslot STEP 0.01 
   LET clk=1-INT(MOD (2*i,2))
   !------------------------------------------------------------------------------  
   !        CLK：システムクロック、test：テスト信号発生器 
   !------------------------------------------------------------------------------   
   CALL  test(i,y0,y1,y2,y3,y4,y5) 
   !###############    論理記述（ネットリスト）  ################################# 
   ! 予約変数(使用できない変数名)  i,clk,tslot,number,xm(),xs(),y0～y7,z0～z7,zm0$～zm7$
   CALL dff(clk,n4,m0,qb0,xm(0),xs(0)) 
   CALL dff(clk,m0,m1,qb1,xm(1),xs(1)) 
   CALL dff(clk,m1,m2,qb2,xm(2),xs(2))
    
   CALL dff(clk,m2,m3,qb3,xm(3),xs(3))
   CALL nand2(n1,m2,m3)
    
   CALL inv1(s1,s)
   CALL nand2(n2,qb3,s1)
   CALL nand2(n3,s,n1)
    
   CALL nand2(n4,n2,n3)
   CALL nand2(n5,s,qb2)
    
   CALL inv1(clk0,clk)
   CALL dff(clk0,n5,m4,qb4,xm(4),xs(4))
   CALL nand2(c,m4,m2)
    
   !-------------   プロット出力の設定　　  -----------------------------------
   LET z0=m1
   LET zm0$="m1"
   LET z1=n6
   LET zm1$="n6"
   LET z2=c
   LET zm2$="c"
   LET z3=m4
   LET zm3$="m4"
   LET z4=m2
   LET zm4$="m2"
   LET z5=m4
   LET zm5$="m4"
   LET z6=s2
   LET zm6$="s2"
   LET z7=y2
   LET zm7$="y2"
   !############################################################################
   CALL plotzz(i,clk,z0,z1,z2,z3,z4,z5,z6,z7)
   CALL plotmm(zm0$,zm1$,zm2$,zm3$,zm4$,zm5$,zm6$,zm7$) 
   !---------------------------------------------------------------------------
NEXT i
CALL pdnn(who$,number,1)
END 

EXTERNAL SUB minv1(a,b)
CALL pmos(a,b,1)
CALL nmos(a,b,0)
END SUB

EXTERNAL SUB mnand2(a,b,c)
LET x=1
CALL pmos(a,b,1)
CALL pmos(a,c,1)
CALL nmos(x,c,0)
CALL nmos(a,b,x)
END SUB

EXTERNAL SUB mnand3(a,b,c,d)
CALL MNAND2(e,b,c)
CALL MINV1(f,d)
CALL MNOR2(g,e,f)
CALL MINV1(a,g)
END SUB


EXTERNAL SUB mnor2(a,b,c)
LET x=0
CALL pmos(x,b,1)
CALL pmos(a,c,x)
CALL nmos(a,b,0)
CALL nmos(a,c,0)
END SUB

EXTERNAL SUB meor2(a,b,c)
CALL mnor2(d,b,c)
CALL mnand2(e,b,c)
CALL minv1(f,e)
CALL mnor2(a,f,d)
END SUB

EXTERNAL SUB mfaCo(a,b,c,d)
CALL mnand2(e,c,d)
CALL mnand2(f,b,d)
CALL mnand2(g,b,c)
CALL mnand3(a,e,f,g)
END SUB

EXTERNAL SUB mfaS(a,b,c,d)
CALL meor2(h,b,c)
CALL meor2(a,d,h) 
END SUB

EXTERNAL SUB mdff(c,d,qo,qb,a,b)
CALL pmos(a,c,d)
CALL minv1(e,a)
CALL minv1(f,e)
CALL nmos(a,c,f)
CALL nmos(b,c,e)
CALL minv1(qo,b)
CALL minv1(qb,qo)
CALL pmos(b,c,qb)
END SUB


MERGE "function.BAS"


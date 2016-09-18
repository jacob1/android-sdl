/*
 * Copyright (c) 2003, 2007-8 Matteo Frigo
 * Copyright (c) 2003, 2007-8 Massachusetts Institute of Technology
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/* This file was automatically generated --- DO NOT EDIT */
/* Generated on Sun Jul 12 06:43:46 EDT 2009 */

#include "../../codelet-rdft.h"

#ifdef HAVE_FMA

/* Generated by: ../../../genfft/gen_hc2hc -fma -reorder-insns -schedule-for-pipeline -compact -variables 4 -pipeline-latency 4 -n 7 -dit -name hf_7 -include hf.h */

/*
 * This function contains 72 FP additions, 66 FP multiplications,
 * (or, 18 additions, 12 multiplications, 54 fused multiply/add),
 * 62 stack variables, 6 constants, and 28 memory accesses
 */
#include "../hf.h"

static void hf_7(float *cr, float *ci, const float *W, stride rs, INT mb, INT me, INT ms)
{
     DK(KP974927912, +0.974927912181823607018131682993931217232785801);
     DK(KP801937735, +0.801937735804838252472204639014890102331838324);
     DK(KP900968867, +0.900968867902419126236102319507445051165919162);
     DK(KP692021471, +0.692021471630095869627814897002069140197260599);
     DK(KP554958132, +0.554958132087371191422194871006410481067288862);
     DK(KP356895867, +0.356895867892209443894399510021300583399127187);
     INT m;
     for (m = mb, W = W + ((mb - 1) * 12); m < me; m = m + 1, cr = cr + ms, ci = ci - ms, W = W + 12, MAKE_VOLATILE_STRIDE(rs)) {
	  E T1, TR, T18, T10, T12, T16, T11, T13;
	  {
	       E T19, T1a, T1i, Te, Tt, Tw, T1b, TM, T1h, Tr, Tu, TS, Tz, TC, Ty;
	       E Tv, TB;
	       T1 = cr[0];
	       T19 = ci[0];
	       {
		    E T9, Tc, TP, Ta, Tb, TO, T7;
		    {
			 E T3, T6, T8, TN, T4, T2, T5;
			 T3 = cr[WS(rs, 1)];
			 T6 = ci[WS(rs, 1)];
			 T2 = W[0];
			 T9 = cr[WS(rs, 6)];
			 Tc = ci[WS(rs, 6)];
			 T8 = W[10];
			 TN = T2 * T6;
			 T4 = T2 * T3;
			 T5 = W[1];
			 TP = T8 * Tc;
			 Ta = T8 * T9;
			 Tb = W[11];
			 TO = FNMS(T5, T3, TN);
			 T7 = FMA(T5, T6, T4);
		    }
		    {
			 E Tg, Tj, Th, TI, Tm, Tp, Tl, Ti, To, TQ, Td, Tf;
			 Tg = cr[WS(rs, 2)];
			 TQ = FNMS(Tb, T9, TP);
			 Td = FMA(Tb, Tc, Ta);
			 Tj = ci[WS(rs, 2)];
			 Tf = W[2];
			 T1a = TO + TQ;
			 TR = TO - TQ;
			 T1i = Td - T7;
			 Te = T7 + Td;
			 Th = Tf * Tg;
			 TI = Tf * Tj;
			 Tm = cr[WS(rs, 5)];
			 Tp = ci[WS(rs, 5)];
			 Tl = W[8];
			 Ti = W[3];
			 To = W[9];
			 {
			      E TJ, Tk, TL, Tq, TK, Tn, Ts;
			      Tt = cr[WS(rs, 3)];
			      TK = Tl * Tp;
			      Tn = Tl * Tm;
			      TJ = FNMS(Ti, Tg, TI);
			      Tk = FMA(Ti, Tj, Th);
			      TL = FNMS(To, Tm, TK);
			      Tq = FMA(To, Tp, Tn);
			      Tw = ci[WS(rs, 3)];
			      Ts = W[4];
			      T1b = TJ + TL;
			      TM = TJ - TL;
			      T1h = Tq - Tk;
			      Tr = Tk + Tq;
			      Tu = Ts * Tt;
			      TS = Ts * Tw;
			 }
			 Tz = cr[WS(rs, 4)];
			 TC = ci[WS(rs, 4)];
			 Ty = W[6];
			 Tv = W[5];
			 TB = W[7];
		    }
	       }
	       {
		    E TF, TT, Tx, TV, TD, T1q, TU, TA;
		    TF = FNMS(KP356895867, Tr, Te);
		    TU = Ty * TC;
		    TA = Ty * Tz;
		    TT = FNMS(Tv, Tt, TS);
		    Tx = FMA(Tv, Tw, Tu);
		    TV = FNMS(TB, Tz, TU);
		    TD = FMA(TB, TC, TA);
		    T1q = FNMS(KP356895867, T1b, T1a);
		    {
			 E TW, TE, T1k, T1f;
			 {
			      E T1e, T1s, TY, T1p, T1u, TH, T1n, T1j, T1c, T1g;
			      T1j = FNMS(KP554958132, T1i, T1h);
			      T1c = TT + TV;
			      TW = TT - TV;
			      T1g = TD - Tx;
			      TE = Tx + TD;
			      {
				   E T1d, T1l, T1r, TX;
				   T1d = FNMS(KP356895867, T1c, T1b);
				   T1l = FNMS(KP356895867, T1a, T1c);
				   T1r = FNMS(KP692021471, T1q, T1c);
				   ci[WS(rs, 6)] = T1a + T1b + T1c + T19;
				   TX = FMA(KP554958132, TW, TR);
				   {
					E T1o, T1t, TG, T1m;
					T1o = FMA(KP554958132, T1h, T1g);
					T1t = FMA(KP554958132, T1g, T1i);
					TG = FNMS(KP692021471, TF, TE);
					cr[0] = T1 + Te + Tr + TE;
					T1e = FNMS(KP692021471, T1d, T1a);
					T1m = FNMS(KP692021471, T1l, T1b);
					T1s = FNMS(KP900968867, T1r, T19);
					TY = FMA(KP801937735, TX, TM);
					T1p = FNMS(KP801937735, T1o, T1i);
					T1u = FMA(KP801937735, T1t, T1h);
					TH = FNMS(KP900968867, TG, T1);
					T1n = FNMS(KP900968867, T1m, T19);
					T1k = FNMS(KP801937735, T1j, T1g);
				   }
			      }
			      ci[WS(rs, 5)] = FMA(KP974927912, T1u, T1s);
			      cr[WS(rs, 6)] = FMS(KP974927912, T1u, T1s);
			      cr[WS(rs, 1)] = FMA(KP974927912, TY, TH);
			      ci[0] = FNMS(KP974927912, TY, TH);
			      ci[WS(rs, 4)] = FMA(KP974927912, T1p, T1n);
			      cr[WS(rs, 5)] = FMS(KP974927912, T1p, T1n);
			      T1f = FNMS(KP900968867, T1e, T19);
			 }
			 {
			      E T14, T17, T15, TZ;
			      T14 = FNMS(KP356895867, TE, Tr);
			      T17 = FNMS(KP554958132, TR, TM);
			      TZ = FNMS(KP356895867, Te, TE);
			      ci[WS(rs, 3)] = FMA(KP974927912, T1k, T1f);
			      cr[WS(rs, 4)] = FMS(KP974927912, T1k, T1f);
			      T15 = FNMS(KP692021471, T14, Te);
			      T18 = FNMS(KP801937735, T17, TW);
			      T10 = FNMS(KP692021471, TZ, Tr);
			      T12 = FMA(KP554958132, TM, TW);
			      T16 = FNMS(KP900968867, T15, T1);
			 }
		    }
	       }
	  }
	  T11 = FNMS(KP900968867, T10, T1);
	  T13 = FNMS(KP801937735, T12, TR);
	  cr[WS(rs, 3)] = FMA(KP974927912, T18, T16);
	  ci[WS(rs, 2)] = FNMS(KP974927912, T18, T16);
	  cr[WS(rs, 2)] = FMA(KP974927912, T13, T11);
	  ci[WS(rs, 1)] = FNMS(KP974927912, T13, T11);
     }
}

static const tw_instr twinstr[] = {
     {TW_FULL, 1, 7},
     {TW_NEXT, 1, 0}
};

static const hc2hc_desc desc = { 7, "hf_7", twinstr, &fftwf_rdft_hf_genus, {18, 12, 54, 0} };

void fftwf_codelet_hf_7 (planner *p) {
     fftwf_khc2hc_register (p, hf_7, &desc);
}
#else				/* HAVE_FMA */

/* Generated by: ../../../genfft/gen_hc2hc -compact -variables 4 -pipeline-latency 4 -n 7 -dit -name hf_7 -include hf.h */

/*
 * This function contains 72 FP additions, 60 FP multiplications,
 * (or, 36 additions, 24 multiplications, 36 fused multiply/add),
 * 29 stack variables, 6 constants, and 28 memory accesses
 */
#include "../hf.h"

static void hf_7(float *cr, float *ci, const float *W, stride rs, INT mb, INT me, INT ms)
{
     DK(KP222520933, +0.222520933956314404288902564496794759466355569);
     DK(KP900968867, +0.900968867902419126236102319507445051165919162);
     DK(KP623489801, +0.623489801858733530525004884004239810632274731);
     DK(KP433883739, +0.433883739117558120475768332848358754609990728);
     DK(KP974927912, +0.974927912181823607018131682993931217232785801);
     DK(KP781831482, +0.781831482468029808708444526674057750232334519);
     INT m;
     for (m = mb, W = W + ((mb - 1) * 12); m < me; m = m + 1, cr = cr + ms, ci = ci - ms, W = W + 12, MAKE_VOLATILE_STRIDE(rs)) {
	  E T1, TT, Tc, TV, TC, TO, Tn, TS, TI, TP, Ty, TU, TF, TQ;
	  T1 = cr[0];
	  TT = ci[0];
	  {
	       E T6, TA, Tb, TB;
	       {
		    E T3, T5, T2, T4;
		    T3 = cr[WS(rs, 1)];
		    T5 = ci[WS(rs, 1)];
		    T2 = W[0];
		    T4 = W[1];
		    T6 = FMA(T2, T3, T4 * T5);
		    TA = FNMS(T4, T3, T2 * T5);
	       }
	       {
		    E T8, Ta, T7, T9;
		    T8 = cr[WS(rs, 6)];
		    Ta = ci[WS(rs, 6)];
		    T7 = W[10];
		    T9 = W[11];
		    Tb = FMA(T7, T8, T9 * Ta);
		    TB = FNMS(T9, T8, T7 * Ta);
	       }
	       Tc = T6 + Tb;
	       TV = TA + TB;
	       TC = TA - TB;
	       TO = Tb - T6;
	  }
	  {
	       E Th, TG, Tm, TH;
	       {
		    E Te, Tg, Td, Tf;
		    Te = cr[WS(rs, 2)];
		    Tg = ci[WS(rs, 2)];
		    Td = W[2];
		    Tf = W[3];
		    Th = FMA(Td, Te, Tf * Tg);
		    TG = FNMS(Tf, Te, Td * Tg);
	       }
	       {
		    E Tj, Tl, Ti, Tk;
		    Tj = cr[WS(rs, 5)];
		    Tl = ci[WS(rs, 5)];
		    Ti = W[8];
		    Tk = W[9];
		    Tm = FMA(Ti, Tj, Tk * Tl);
		    TH = FNMS(Tk, Tj, Ti * Tl);
	       }
	       Tn = Th + Tm;
	       TS = TG + TH;
	       TI = TG - TH;
	       TP = Th - Tm;
	  }
	  {
	       E Ts, TD, Tx, TE;
	       {
		    E Tp, Tr, To, Tq;
		    Tp = cr[WS(rs, 3)];
		    Tr = ci[WS(rs, 3)];
		    To = W[4];
		    Tq = W[5];
		    Ts = FMA(To, Tp, Tq * Tr);
		    TD = FNMS(Tq, Tp, To * Tr);
	       }
	       {
		    E Tu, Tw, Tt, Tv;
		    Tu = cr[WS(rs, 4)];
		    Tw = ci[WS(rs, 4)];
		    Tt = W[6];
		    Tv = W[7];
		    Tx = FMA(Tt, Tu, Tv * Tw);
		    TE = FNMS(Tv, Tu, Tt * Tw);
	       }
	       Ty = Ts + Tx;
	       TU = TD + TE;
	       TF = TD - TE;
	       TQ = Tx - Ts;
	  }
	  {
	       E TL, TK, TZ, T10;
	       cr[0] = T1 + Tc + Tn + Ty;
	       TL = FMA(KP781831482, TC, KP974927912 * TI) + (KP433883739 * TF);
	       TK = FMA(KP623489801, Tc, T1) + FNMA(KP900968867, Ty, KP222520933 * Tn);
	       ci[0] = TK - TL;
	       cr[WS(rs, 1)] = TK + TL;
	       ci[WS(rs, 6)] = TV + TS + TU + TT;
	       TZ = FMA(KP781831482, TO, KP433883739 * TQ) - (KP974927912 * TP);
	       T10 = FMA(KP623489801, TV, TT) + FNMA(KP900968867, TU, KP222520933 * TS);
	       cr[WS(rs, 6)] = TZ - T10;
	       ci[WS(rs, 5)] = TZ + T10;
	  }
	  {
	       E TX, TY, TR, TW;
	       TX = FMA(KP974927912, TO, KP433883739 * TP) - (KP781831482 * TQ);
	       TY = FMA(KP623489801, TU, TT) + FNMA(KP900968867, TS, KP222520933 * TV);
	       cr[WS(rs, 5)] = TX - TY;
	       ci[WS(rs, 4)] = TX + TY;
	       TR = FMA(KP433883739, TO, KP781831482 * TP) + (KP974927912 * TQ);
	       TW = FMA(KP623489801, TS, TT) + FNMA(KP222520933, TU, KP900968867 * TV);
	       cr[WS(rs, 4)] = TR - TW;
	       ci[WS(rs, 3)] = TR + TW;
	  }
	  {
	       E TN, TM, TJ, Tz;
	       TN = FMA(KP433883739, TC, KP974927912 * TF) - (KP781831482 * TI);
	       TM = FMA(KP623489801, Tn, T1) + FNMA(KP222520933, Ty, KP900968867 * Tc);
	       ci[WS(rs, 2)] = TM - TN;
	       cr[WS(rs, 3)] = TM + TN;
	       TJ = FNMS(KP781831482, TF, KP974927912 * TC) - (KP433883739 * TI);
	       Tz = FMA(KP623489801, Ty, T1) + FNMA(KP900968867, Tn, KP222520933 * Tc);
	       ci[WS(rs, 1)] = Tz - TJ;
	       cr[WS(rs, 2)] = Tz + TJ;
	  }
     }
}

static const tw_instr twinstr[] = {
     {TW_FULL, 1, 7},
     {TW_NEXT, 1, 0}
};

static const hc2hc_desc desc = { 7, "hf_7", twinstr, &fftwf_rdft_hf_genus, {36, 24, 36, 0} };

void fftwf_codelet_hf_7 (planner *p) {
     fftwf_khc2hc_register (p, hf_7, &desc);
}
#endif				/* HAVE_FMA */

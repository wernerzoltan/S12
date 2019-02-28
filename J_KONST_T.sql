create or replace PACKAGE "J_KONST_T" as 
  
  -------- 2017e TERMÉSZETBENI SZORZÓK KIEMELVE ------------

  p_15_term_szorzo CONSTANT NUMBER := 0.2406; 
                                         -- 1.7733 volt 2018.03.26-ig
                                         -- 0.3356 volt 2017.05.24-ig (2015v)
                                         -- 0.0691 volt 2017.04.26
  p_16_term_szorzo CONSTANT NUMBER := 0.3958;
                                         -- 3.2890 volt 2018.03.26-ig
                                         -- 0.5787 volt 2017.05.24-ig (2015v)
                                         -- 1.4548 volt 2017.04.26
  p_262_term_szorzo CONSTANT NUMBER := 0.0262; 
                                          -- 0.0457 volt 2018.03.26-ig
                                          -- 0.05 volt 2017.05.24-ig (2015v)
                                          -- 0.0379 volt 2017.04.26
  d_1121_term_szorzo CONSTANT NUMBER := 0.2344;  
                                            -- 2.1750 volt 2018.03.26-ig
                                            -- 0.3525 volt 2017.05.24-ig (2015v)
                                            -- 0.4641 volt 2017.04.27
  
  -- j_kettos_fugg altal hasznalt szorzok (uj)  
  d_1123_szorzo constant number := 0.1777; -- ugyanannyi mint a d_11127. 2018.09.11
  d_11127_szorzo CONSTANT NUMBER := 0.1777; --* 0.5 (a képletben) 2018.09.11
  -- a többit még nem emeltem át a J_KETTOS_FUGG illetve a séma csomagokban,
  -- de átemelhetők.

end j_konst_t;
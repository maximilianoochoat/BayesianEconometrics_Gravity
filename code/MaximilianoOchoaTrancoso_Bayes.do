/*
FLAR - Bayesian extension
Maximiliano Ochoa Trancoso
*/
//This do replicates all the figures and tables from my submission.
//In each figure section you just have to change the directory in which the data is available
//Figure 1
clear all
cd "C:/Users/maxit/OneDrive/Escritorio/UW/FLAR/Data"
import delimited world_bank_tradeaspercGDP.csv
tset year
grstyle init
grstyle set plain, horizontal grid
grstyle set legend 10, inside
grstyle set linewidth 1pt: p
grstyle set size 10pt: heading
grstyle set size 6pt: subheading
grstyle set margin "0 0 0 0"
grstyle set color tfl
grstyle set graphsize 10cm 15cm

tsline world latam china usa, ///
	legend(position(5) ring(0))  /// 
	xlabel(1970(10)2024 ,nogrid) xmtick(1970(1)2024) xtitle("")	///
	ylabel(0(10)65, glpattern(solid)) ymtick(0(1)65) ytitle("(%)") ///
	xline(2008, lpattern(dash)) ///
	title("Trade (% of GDP)") 

graph export "tradeasperc.eps", replace
	

//Working with FLAR data
clear all 

cd "C:/Users/maxit/OneDrive/Escritorio/UW/FLAR/Data"
import excel SIE, sheet("datos_sie_completos") firstrow
levelsof indicatorNameENShort , local(indicators)
foreach i of local indicators {
     display "`i'"
 }

/* Variables
Capital and Financial accounts, US dollars
Capital and Financial accounts, US dollars 12-months rolling sum
Capital and Financial accounts, US dollars 12-months rolling sum  as percentage GDP USD
Consumer price index
Consumer price index  annual variation
Consumer price index  period variation
Current account, US dollars
Current account, US dollars 12-months rolling sum
Current account, US dollars 12-months rolling sum  as percentage GDP USD
Debt service (external debt), US dollars
Debt service (external debt), US dollars 12-months rolling sum
Debt service (external debt), US dollars 12-months rolling sum  as percentage GDP USD
Deposits in domestic currency, National Currency
Deposits in domestic currency, National Currency  annual variation
Deposits in domestic currency, National Currency  as percentage GDP XDC
Deposits in domestic currency, National Currency  period variation
Deposits in foreign currencies, National Currency
Deposits in foreign currencies, National Currency  annual variation
Deposits in foreign currencies, National Currency  as percentage GDP XDC
Deposits in foreign currencies, National Currency  period variation
Equity/Risk Weighted Assets
Exchange rate, end of period (National currency per USD) 
Exchange rate, end of period (National currency per USD)   annual variation
Exchange rate, end of period (National currency per USD)   period variation
Exchange rate, period average (National currency per USD) 
Exchange rate, period average (National currency per USD)   annual variation
Exchange rate, period average (National currency per USD)   period variation
Exports (FOB), US dollars
Exports (FOB), US dollars 12-months rolling sum
Exports (FOB), US dollars 12-months rolling sum  as percentage GDP USD
Exports (goods), US dollars
Exports (goods), US dollars 12-months rolling sum
Exports (goods), US dollars 12-months rolling sum  as percentage GDP USD
External debt, US dollars
External debt, US dollars  as percentage GDP USD
External public debt, National Currency
External public debt, National Currency  as percentage GDP XDC
Imports (CIF), US dollars 
Imports (CIF), US dollars  12-months rolling sum
Imports (CIF), US dollars  12-months rolling sum  as percentage GDP USD
Imports (goods), US dollars
Imports (goods), US dollars 12-months rolling sum
Imports (goods), US dollars 12-months rolling sum  as percentage GDP USD
Loans (domestic currency), National Currency
Loans (domestic currency), National Currency  annual variation
Loans (domestic currency), National Currency  as percentage GDP XDC
Loans (domestic currency), National Currency  period variation
Loans (foreign currencies), National Currency
Loans (foreign currencies), National Currency  annual variation
Loans (foreign currencies), National Currency  as percentage GDP XDC
Loans (foreign currencies), National Currency  period variation
M2, National Currency
M2, National Currency  annual variation
M2, National Currency  as percentage GDP XDC
M2, National Currency  period variation
Monetary base, National Currency
Monetary base, National Currency  annual variation
Monetary base, National Currency  as percentage GDP XDC
Monetary base, National Currency  period variation
Nominal Gross Domestic Product, National Currency
Nominal Gross Domestic Product, National Currency  annual variation
Nominal Gross Domestic Product, National Currency  period variation
Nominal Gross Domestic Product, National Currency 12-months rolling sum
Nominal Gross Domestic Product, US dollars
Nominal Gross Domestic Product, US dollars  annual variation
Nominal Gross Domestic Product, US dollars  period variation
Nominal Gross Domestic Product, US dollars 12-months rolling sum
Non-performing Loans/ Total Gross Loans
Policy-related interest rate
Primary income, US dollars
Primary income, US dollars 12-months rolling sum
Primary income, US dollars 12-months rolling sum  as percentage GDP USD
Public sector (global balance), National Currency
Public sector (global balance), National Currency 12-months rolling sum
Public sector (global balance), National Currency 12-months rolling sum  as percentage GDP XDC
Public sector (primary balance), National Currency
Public sector (primary balance), National Currency 12-months rolling sum
Public sector (primary balance), National Currency 12-months rolling sum  as percentage GDP XDC
Real Gross Domestic Product, National Currency
Real Gross Domestic Product, National Currency  annual variation
Real Gross Domestic Product, National Currency  period variation
Real Gross Domestic Product, National Currency 12-months rolling sum
Secondary income, US dollars
Secondary income, US dollars 12-months rolling sum
Secondary income, US dollars 12-months rolling sum  as percentage GDP USD
Terms of trade
Terms of trade  annual variation
Terms of trade  period variation
Total net international reserves, US dollars
Total net international reserves, US dollars  as percentage GDP USD
Total public debt, National Currency
Total public debt, National Currency  as percentage GDP XDC
Trade in services, US dollars
Trade in services, US dollars 12-months rolling sum
Trade in services, US dollars 12-months rolling sum  as percentage GDP USD
Underemployment rate
Unemployment rate
*/
//Venezuela has quarterly observations, comapred to monthly obervations of every other country.
// I collapse all observations to quarterly data for a homogenous dataset
encode refAreaName, gen(pais)
tostring timePeriod, replace force
gen qdate = .
replace qdate = qofd(dofm(monthly(timePeriod, "YM"))) if regexm(timePeriod, "^[0-9]{4}-[0-9]{2}$")
replace qdate = quarterly(timePeriod, "YQ") if regexm(timePeriod, "^[0-9]{4}-Q[1-4]$")
format qdate %tq
list timePeriod qdate in 1/20, clean
collapse (mean) obsValue, by(pais indicatorNameENShort qdate)

gen ind = ""

replace ind = "capfin_usd" if indicatorNameENShort == "Capital and Financial accounts, US dollars"
replace ind = "capfin_12m" if indicatorNameENShort == "Capital and Financial accounts, US dollars 12-months rolling sum"
replace ind = "capfin_gdp" if indicatorNameENShort == "Capital and Financial accounts, US dollars 12-months rolling sum  as percentage GDP USD"

replace ind = "cpi" if indicatorNameENShort == "Consumer price index"
replace ind = "cpi_yoy" if indicatorNameENShort == "Consumer price index  annual variation"
replace ind = "cpi_per" if indicatorNameENShort == "Consumer price index  period variation"

replace ind = "ca_usd" if indicatorNameENShort == "Current account, US dollars"
replace ind = "ca_12m" if indicatorNameENShort == "Current account, US dollars 12-months rolling sum"
replace ind = "ca_gdp" if indicatorNameENShort == "Current account, US dollars 12-months rolling sum  as percentage GDP USD"

replace ind = "debtserv_usd" if indicatorNameENShort == "Debt service (external debt), US dollars"
replace ind = "debtserv_12m" if indicatorNameENShort == "Debt service (external debt), US dollars 12-months rolling sum"
replace ind = "debtserv_gdp" if indicatorNameENShort == "Debt service (external debt), US dollars 12-months rolling sum  as percentage GDP USD"

replace ind = "depdom_lcu" if indicatorNameENShort == "Deposits in domestic currency, National Currency"
replace ind = "depdom_yoy" if indicatorNameENShort == "Deposits in domestic currency, National Currency  annual variation"
replace ind = "depdom_gdp" if indicatorNameENShort == "Deposits in domestic currency, National Currency  as percentage GDP XDC"
replace ind = "depdom_per" if indicatorNameENShort == "Deposits in domestic currency, National Currency  period variation"

replace ind = "depfx_lcu" if indicatorNameENShort == "Deposits in foreign currencies, National Currency"
replace ind = "depfx_yoy" if indicatorNameENShort == "Deposits in foreign currencies, National Currency  annual variation"
replace ind = "depfx_gdp" if indicatorNameENShort == "Deposits in foreign currencies, National Currency  as percentage GDP XDC"
replace ind = "depfx_per" if indicatorNameENShort == "Deposits in foreign currencies, National Currency  period variation"

replace ind = "equity_rwa" if indicatorNameENShort == "Equity/Risk Weighted Assets"

replace ind = "xr_eop" if indicatorNameENShort == "Exchange rate, end of period (National currency per USD) "
replace ind = "xr_eop_yoy" if indicatorNameENShort == "Exchange rate, end of period (National currency per USD)   annual variation"
replace ind = "xr_eop_per" if indicatorNameENShort == "Exchange rate, end of period (National currency per USD)   period variation"

replace ind = "xr_avg" if indicatorNameENShort == "Exchange rate, period average (National currency per USD) "
replace ind = "xr_avg_yoy" if indicatorNameENShort == "Exchange rate, period average (National currency per USD)   annual variation"
replace ind = "xr_avg_per" if indicatorNameENShort == "Exchange rate, period average (National currency per USD)   period variation"

replace ind = "expfob_usd" if indicatorNameENShort == "Exports (FOB), US dollars"
replace ind = "expfob_12m" if indicatorNameENShort == "Exports (FOB), US dollars 12-months rolling sum"
replace ind = "expfob_gdp" if indicatorNameENShort == "Exports (FOB), US dollars 12-months rolling sum  as percentage GDP USD"

replace ind = "expgoods_usd" if indicatorNameENShort == "Exports (goods), US dollars"
replace ind = "expgoods_12m" if indicatorNameENShort == "Exports (goods), US dollars 12-months rolling sum"
replace ind = "expgoods_gdp" if indicatorNameENShort == "Exports (goods), US dollars 12-months rolling sum  as percentage GDP USD"

replace ind = "extdebt_usd" if indicatorNameENShort == "External debt, US dollars"
replace ind = "extdebt_gdp" if indicatorNameENShort == "External debt, US dollars  as percentage GDP USD"

replace ind = "extpubdebt" if indicatorNameENShort == "External public debt, National Currency"
replace ind = "extpubdebt_gdp" if indicatorNameENShort == "External public debt, National Currency  as percentage GDP XDC"

replace ind = "impcif_usd" if indicatorNameENShort == "Imports (CIF), US dollars "
replace ind = "impcif_12m" if indicatorNameENShort == "Imports (CIF), US dollars  12-months rolling sum"
replace ind = "impcif_gdp" if indicatorNameENShort == "Imports (CIF), US dollars  12-months rolling sum  as percentage GDP USD"

replace ind = "impgoods_usd" if indicatorNameENShort == "Imports (goods), US dollars"
replace ind = "impgoods_12m" if indicatorNameENShort == "Imports (goods), US dollars 12-months rolling sum"
replace ind = "impgoods_gdp" if indicatorNameENShort == "Imports (goods), US dollars 12-months rolling sum  as percentage GDP USD"

replace ind = "loandom_lcu" if indicatorNameENShort == "Loans (domestic currency), National Currency"
replace ind = "loandom_yoy" if indicatorNameENShort == "Loans (domestic currency), National Currency  annual variation"
replace ind = "loandom_gdp" if indicatorNameENShort == "Loans (domestic currency), National Currency  as percentage GDP XDC"
replace ind = "loandom_per" if indicatorNameENShort == "Loans (domestic currency), National Currency  period variation"

replace ind = "loanfx_lcu" if indicatorNameENShort == "Loans (foreign currencies), National Currency"
replace ind = "loanfx_yoy" if indicatorNameENShort == "Loans (foreign currencies), National Currency  annual variation"
replace ind = "loanfx_gdp" if indicatorNameENShort == "Loans (foreign currencies), National Currency  as percentage GDP XDC"
replace ind = "loanfx_per" if indicatorNameENShort == "Loans (foreign currencies), National Currency  period variation"

replace ind = "m2_lcu" if indicatorNameENShort == "M2, National Currency"
replace ind = "m2_yoy" if indicatorNameENShort == "M2, National Currency  annual variation"
replace ind = "m2_gdp" if indicatorNameENShort == "M2, National Currency  as percentage GDP XDC"
replace ind = "m2_per" if indicatorNameENShort == "M2, National Currency  period variation"

replace ind = "mbase_lcu" if indicatorNameENShort == "Monetary base, National Currency"
replace ind = "mbase_yoy" if indicatorNameENShort == "Monetary base, National Currency  annual variation"
replace ind = "mbase_gdp" if indicatorNameENShort == "Monetary base, National Currency  as percentage GDP XDC"
replace ind = "mbase_per" if indicatorNameENShort == "Monetary base, National Currency  period variation"

replace ind = "gdpnom_lcu" if indicatorNameENShort == "Nominal Gross Domestic Product, National Currency"
replace ind = "gdpnom_lcu_yoy" if indicatorNameENShort == "Nominal Gross Domestic Product, National Currency  annual variation"
replace ind = "gdpnom_lcu_per" if indicatorNameENShort == "Nominal Gross Domestic Product, National Currency  period variation"
replace ind = "gdpnom_lcu_12m" if indicatorNameENShort == "Nominal Gross Domestic Product, National Currency 12-months rolling sum"

replace ind = "gdpnom_usd" if indicatorNameENShort == "Nominal Gross Domestic Product, US dollars"
replace ind = "gdpnom_usd_yoy" if indicatorNameENShort == "Nominal Gross Domestic Product, US dollars  annual variation"
replace ind = "gdpnom_usd_per" if indicatorNameENShort == "Nominal Gross Domestic Product, US dollars  period variation"
replace ind = "gdpnom_usd_12m" if indicatorNameENShort == "Nominal Gross Domestic Product, US dollars 12-months rolling sum"

replace ind = "npl_loans" if indicatorNameENShort == "Non-performing Loans/ Total Gross Loans"
replace ind = "policy_rate" if indicatorNameENShort == "Policy-related interest rate"

replace ind = "priminc_usd" if indicatorNameENShort == "Primary income, US dollars"
replace ind = "priminc_12m" if indicatorNameENShort == "Primary income, US dollars 12-months rolling sum"
replace ind = "priminc_gdp" if indicatorNameENShort == "Primary income, US dollars 12-months rolling sum  as percentage GDP USD"

replace ind = "pubglobbal" if indicatorNameENShort == "Public sector (global balance), National Currency"
replace ind = "pubglobbal_12m" if indicatorNameENShort == "Public sector (global balance), National Currency 12-months rolling sum"
replace ind = "pubglobbal_gdp" if indicatorNameENShort == "Public sector (global balance), National Currency 12-months rolling sum  as percentage GDP XDC"

replace ind = "pubprimbal" if indicatorNameENShort == "Public sector (primary balance), National Currency"
replace ind = "pubprimbal_12m" if indicatorNameENShort == "Public sector (primary balance), National Currency 12-months rolling sum"
replace ind = "pubprimbal_gdp" if indicatorNameENShort == "Public sector (primary balance), National Currency 12-months rolling sum  as percentage GDP XDC"

replace ind = "gdpreal_lcu" if indicatorNameENShort == "Real Gross Domestic Product, National Currency"
replace ind = "gdpreal_lcu_yoy" if indicatorNameENShort == "Real Gross Domestic Product, National Currency  annual variation"
replace ind = "gdpreal_lcu_per" if indicatorNameENShort == "Real Gross Domestic Product, National Currency  period variation"
replace ind = "gdpreal_lcu_12m" if indicatorNameENShort == "Real Gross Domestic Product, National Currency 12-months rolling sum"

replace ind = "secinc_usd" if indicatorNameENShort == "Secondary income, US dollars"
replace ind = "secinc_12m" if indicatorNameENShort == "Secondary income, US dollars 12-months rolling sum"
replace ind = "secinc_gdp" if indicatorNameENShort == "Secondary income, US dollars 12-months rolling sum  as percentage GDP USD"

replace ind = "tot" if indicatorNameENShort == "Terms of trade"
replace ind = "tot_yoy" if indicatorNameENShort == "Terms of trade  annual variation"
replace ind = "tot_per" if indicatorNameENShort == "Terms of trade  period variation"

replace ind = "reserves_usd" if indicatorNameENShort == "Total net international reserves, US dollars"
replace ind = "reserves_gdp" if indicatorNameENShort == "Total net international reserves, US dollars  as percentage GDP USD"

replace ind = "pubdebt_lcu" if indicatorNameENShort == "Total public debt, National Currency"
replace ind = "pubdebt_gdp" if indicatorNameENShort == "Total public debt, National Currency  as percentage GDP XDC"

replace ind = "services_usd" if indicatorNameENShort == "Trade in services, US dollars"
replace ind = "services_12m" if indicatorNameENShort == "Trade in services, US dollars 12-months rolling sum"
replace ind = "services_gdp" if indicatorNameENShort == "Trade in services, US dollars 12-months rolling sum  as percentage GDP USD"

replace ind = "underemp" if indicatorNameENShort == "Underemployment rate"
replace ind = "unemp" if indicatorNameENShort == "Unemployment rate"

// I reshape the databse so that every variable has its own column
list indicatorNameENShort if ind == "", clean noobs
drop if ind == ""
collapse (mean) obsValue, by(pais qdate ind)
rename obsValue v
reshape wide v, i(pais qdate) j(ind) string

foreach var of varlist v* {
    local newname = substr("`var'", 2, .)
    rename `var' `newname'
}

egen pais_id = group(pais)
xtset pais_id qdate

keep if qdate >= tq(2003q1)
keep if qdate<= tq(2025q2)
// Venezuela last available observation is 2023 q2
//Figure 3
preserve

collapse ///
    (mean) mean_tot=tot_yoy ///
    (p25) p25_tot=tot_yoy ///
    (p75) p75_tot=tot_yoy ///
    (count) n_tot=tot_yoy, ///
    by(qdate)

replace mean_tot = . if n_tot < 5
replace p25_tot = . if n_tot < 5
replace p75_tot = . if n_tot < 5

twoway ///
    (rarea p75_tot p25_tot qdate, sort) ///
    (line mean_tot qdate, cmissing(n) lwidth(medthick)), ///
    title("Terms-of-Trade Shocks (LAC)") ///
    subtitle("Annual variation; shaded area = interquartile range") ///
    xtitle("") ///
    ytitle("Terms of trade, annual variation") ///
    yline(0, lpattern(dash)) ///
    xlabel(, angle(45)) ///
	ylabel(-.3(.1).5) ///
    legend(order(1 "Interquartile range" 2 "Regional average")) ///
    graphregion(color(white)) ///
    plotregion(color(white))
graph export "totitq.eps", replace
restore
//Figure 4
preserve
gen trade_open = expfob_gdp + impcif_gdp
drop if pais == 13
keep pais qdate trade_open reserves_gdp
keep if !missing(trade_open, reserves_gdp)

bysort pais (qdate): keep if _n == _N

twoway ///
    (scatter reserves_gdp trade_open, mlabel(pais)), ///
    title("LAC Vulnerability to Geoeconomic Fragmentation") ///
    subtitle("Trade openness vs reserve buffers; latest available observation") ///
    xtitle("Trade openness: exports + imports as % of GDP") ///
    ytitle("International reserves as % of GDP") ///
	xlabel(0(.1)1) ///
	ylabel(0(.05).4) ///
    graphregion(color(white)) ///
    plotregion(color(white))
graph export "exp.eps", replace
restore
/////////////////
//generating the groups for more vulnerable countries
capture drop tag_country total_quarters

egen tag_country = tag(pais)

summ qdate
scalar total_quarters = r(max) - r(min) + 1

capture drop mean_tot_country n_tot_country coverage_tot ///
    med_tot vuln_tot

bysort pais: egen mean_tot_country = mean(tot)
bysort pais: egen n_tot_country = count(tot)

gen coverage_tot = n_tot_country / scalar(total_quarters)

summ mean_tot_country if tag_country == 1 & n_tot_country > 0, detail
scalar med_tot = r(p50)

gen vuln_tot = .
replace vuln_tot = 1 if n_tot_country > 0 & mean_tot_country <  scalar(med_tot)
replace vuln_tot = 0 if n_tot_country > 0 & mean_tot_country >= scalar(med_tot)

label define vuln_tot_lbl ///
    0 "Less vulnerable: above-median terms of trade" ///
    1 "More vulnerable: below-median terms of trade", replace

label values vuln_tot vuln_tot_lbl

capture drop trade_open mean_trade_open n_trade_open ///
    coverage_trade_open med_trade_open vuln_trade_open

gen trade_open = expfob_gdp + impcif_gdp

bysort pais: egen mean_trade_open = mean(trade_open)
bysort pais: egen n_trade_open = count(trade_open)

gen coverage_trade_open = n_trade_open / scalar(total_quarters)

summ mean_trade_open if tag_country == 1 & n_trade_open > 0, detail
scalar med_trade_open = r(p50)

gen vuln_trade_open = .
replace vuln_trade_open = 1 if n_trade_open > 0 ///
    & mean_trade_open >= scalar(med_trade_open)

replace vuln_trade_open = 0 if n_trade_open > 0 ///
    & mean_trade_open < scalar(med_trade_open)

label define vuln_trade_open_lbl ///
    0 "Less vulnerable: below-median trade openness" ///
    1 "More vulnerable: above-median trade openness", replace

label values vuln_trade_open vuln_trade_open_lbl

//Table 1
clear all
cd "C:/Users/maxit/OneDrive/Escritorio/UW/FLAR/Data"
import delimited GeopoliticalFragmentationIndex.csv
collapse (mean) common trade financial mobility political ///
    useublocfragmentation chinarussiablocfragmentation othersblocfragmentation, by(year)
	
save "geopol_index_means.dta", replace

use "C:\Users\maxit\Downloads\Gravity_dta_V202211\Gravity_V202211.dta" 
egen panel_id = group(country_id_o country_id_d)
xtset panel_id year, yearly
egen country_i = group(country_id_o)
egen country_j = group(country_id_d)

merge m:1 year using "geopol_index_means.dta"
drop if _merge == 2
drop if _merge == 1
save "gravity.dta", replace

gen lac_o = 0

replace lac_o = 1 if inlist(iso3_o, "ARG", "BOL", "BRA", "CHL", "COL")
replace lac_o = 1 if inlist(iso3_o, "CRI", "CUB", "DOM", "ECU", "SLV")
replace lac_o = 1 if inlist(iso3_o, "GTM", "HND", "MEX", "NIC", "PAN")
replace lac_o = 1 if inlist(iso3_o, "PRY", "PER", "URY", "VEN", "BLZ")
replace lac_o = 1 if inlist(iso3_o, "GUY", "SUR", "HTI")

gen lac_d = 0

replace lac_d = 1 if inlist(iso3_d, "ARG", "BOL", "BRA", "CHL", "COL")
replace lac_d = 1 if inlist(iso3_d, "CRI", "CUB", "DOM", "ECU", "SLV")
replace lac_d = 1 if inlist(iso3_d, "GTM", "HND", "MEX", "NIC", "PAN")
replace lac_d = 1 if inlist(iso3_d, "PRY", "PER", "URY", "VEN", "BLZ")
replace lac_d = 1 if inlist(iso3_d, "GUY", "SUR", "HTI")

gen lac_pair = lac_o == 1 | lac_d == 1
gen lac_both = lac_o == 1 & lac_d == 1

gen common_lac_pair = common * (lac_pair == 1)
gen common_lac_both = common * (lac_both == 1)

gen common_lac_pair_fta = common * (lac_pair == 1) * (fta_wto == 1)
gen common_lac_both_fta = common * (lac_both == 1) * (fta_wto == 1)

gen common_fta = common * (fta_wto == 1)

gen pair_type = .
replace pair_type = 0 if lac_o == 0 & lac_d == 0
replace pair_type = 1 if lac_o == 1 & lac_d == 1
replace pair_type = 2 if lac_o == 1 & lac_d == 0
replace pair_type = 3 if lac_o == 0 & lac_d == 1

label define pairtype 0 "Non-LAC to Non-LAC" ///
                      1 "LAC to LAC" ///
                      2 "LAC to Non-LAC" ///
                      3 "Non-LAC to LAC"
label values pair_type pairtype

gen common_lac_lac = common * (pair_type == 1) 
gen common_lac_nonlac = common * (pair_type == 2)
gen common_nonlac_lac = common * (pair_type == 3)

gen common_lac_lac_fta = common * (pair_type == 1) * (fta_wto == 1)
gen common_lac_nonlac_fta = common * (pair_type == 2) * (fta_wto == 1)
gen common_nonlac_lac_fta = common * (pair_type == 3) * (fta_wto == 1)


eststo clear

eststo m1: ppmlhdfe tradeflow_baci common_lac_pair, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons
estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

eststo m2: ppmlhdfe tradeflow_baci common_lac_lac, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons
estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

eststo m3: ppmlhdfe tradeflow_baci ///
    common_lac_lac common_lac_nonlac common_nonlac_lac, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons
estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

eststo m4: ppmlhdfe tradeflow_baci common_lac_lac ///
    common_lac_lac_fta common_fta, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons
estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

eststo m5: ppmlhdfe tradeflow_baci ///
    common_lac_lac common_lac_nonlac common_nonlac_lac ///
    common_lac_lac_fta common_lac_nonlac_fta ///
    common_nonlac_lac_fta common_fta, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons
estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

eststo m6: ppmlhdfe tradeflow_baci ///
    common_lac_lac common_lac_nonlac common_nonlac_lac ///
    common_lac_lac_fta common_lac_nonlac_fta ///
    common_nonlac_lac_fta common_fta if year >= 2008, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons 
estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

eststo m7: ppmlhdfe tradeflow_baci ///
    common_lac_lac common_lac_nonlac common_nonlac_lac ///
    common_lac_lac_fta common_lac_nonlac_fta ///
    common_nonlac_lac_fta common_fta if year < 2008, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons 
estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

esttab m2 m1 m3 m4 m5 m6 m7 using "ppml_results_multiple.tex", replace ///
    tex ///
    se ///
    b(3) se(3) ///
	nomtitles ///
	drop(_cons, relax) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
	coeflabels( ///
    common_lac_pair        "GFI_t × LAC - partner" ///
    common_lac_both        "GFI_t × LAC - intraregion" ///
    common_lac_lac         "GFI_t × LAC - intraregion" ///
    common_lac_nonlac      "GFI_t × LAC - exporter" ///
    common_nonlac_lac      "GFI_t × LAC - importer" ///
    common_lac_both_fta    "GFI_t × LAC - intraregion × FTA" ///
    common_lac_lac_fta     "GFI_t × LAC - intraregion × FTA" ///
    common_lac_nonlac_fta  "GFI_t × LAC - exporter × FTA" ///
    common_nonlac_lac_fta  "GFI_t × LAC - importer × FTA" ///
    common_fta             "GFI_t × FTA" ///
	)	 ///
    stats(N clusters pseudo_r2 pair_fe year_fe, ///
        labels("Observations" ///
               "Country-pair clusters" ///
               "Pseudo R-squared" ///
               "Pair FE" ///
               "Year FE") ///
        fmt(0 0 3 s s)) ///
    title("PPML Estimates with Pair and Year Fixed Effects") ///
	addnotes("Cluster-robust standard errors are clustered at the country-pair level." ///
				"Pair and year fixed effects are included in all specifications. Constants are not reported.") ///
    compress
	
// When running the models woth other trade flows from Comtrade and FMI, the estimates become stronger 

/*
gen political_lac_pair = political * (lac_pair == 1)
gen political_lac_both = political * (lac_both == 1)

ppmlhdfe tradeflow_baci political_lac_pair, ///
    absorb(panel_id year) ///
    cluster(panel_id)
	
ppmlhdfe tradeflow_baci political_lac_both, ///
    absorb(panel_id year) ///
    cluster(panel_id)

gen political_lac_lac = political * (pair_type == 1)
gen political_lac_nonlac = political * (pair_type == 2)
gen political_nonlac_lac = political * (pair_type == 3)

ppmlhdfe tradeflow_baci ///
    political_lac_lac political_lac_nonlac political_nonlac_lac, ///
    absorb(panel_id year) ///
    cluster(panel_id)
*/

/*
When reestimating some estimates wiht toher meausures of fragmentations the 
estimate survives
gen trade_lac_pair = trade * (lac_pair == 1)
gen trade_lac_both = trade * (lac_both == 1)

gen trade_lac_pair_fta = trade * (lac_pair == 1) * (fta_wto == 1)
gen trade_lac_both_fta = trade * (lac_both == 1) * (fta_wto == 1)

gen trade_fta = trade * (fta_wto == 1)

ppmlhdfe tradeflow_baci trade trade_lac_pair ///
    trade_lac_pair_fta trade_fta, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

ppmlhdfe tradeflow_baci trade trade_lac_pair, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

ppmlhdfe tradeflow_baci trade trade_lac_both, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

ppmlhdfe tradeflow_baci trade trade_lac_both ///
    trade_lac_both_fta trade_fta, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons
////////////////////

gen financial_lac_pair = financial * (lac_pair == 1)
gen financial_lac_both = financial * (lac_both == 1)

gen financial_lac_pair_fta = financial * (lac_pair == 1) * (fta_wto == 1)
gen financial_lac_both_fta = financial * (lac_both == 1) * (fta_wto == 1)

gen financial_fta = financial * (fta_wto == 1)

ppmlhdfe tradeflow_baci financial financial_lac_pair ///
    financial_lac_pair_fta financial_fta, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

ppmlhdfe tradeflow_baci financial financial_lac_pair, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

ppmlhdfe tradeflow_baci financial financial_lac_both, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

ppmlhdfe tradeflow_baci financial financial_lac_both ///
    financial_lac_both_fta financial_fta, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

///////////////////////////////

gen mobility_lac_pair = mobility * (lac_pair == 1)
gen mobility_lac_both = mobility * (lac_both == 1)

gen mobility_lac_pair_fta = mobility * (lac_pair == 1) * (fta_wto == 1)
gen mobility_lac_both_fta = mobility * (lac_both == 1) * (fta_wto == 1)

gen mobility_fta = mobility * (fta_wto == 1)

ppmlhdfe tradeflow_baci mobility mobility_lac_pair ///
    mobility_lac_pair_fta mobility_fta, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

ppmlhdfe tradeflow_baci mobility mobility_lac_pair, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

ppmlhdfe tradeflow_baci mobility mobility_lac_both, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

ppmlhdfe tradeflow_baci mobility mobility_lac_both ///
    mobility_lac_both_fta mobility_fta, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons
	
//////////////
 */

//Figure 2
clear all
cd "C:/Users/maxit/OneDrive/Escritorio/UW/FLAR/Data"
import delimited GeopoliticalFragmentationIndex.csv
collapse (mean) common trade financial mobility political ///
    useublocfragmentation chinarussiablocfragmentation othersblocfragmentation, by(year)
	
save "geopol_index_means.dta", replace

use "C:\Users\maxit\Downloads\Gravity_dta_V202211\Gravity_V202211.dta" 
egen panel_id = group(country_id_o country_id_d)
xtset panel_id year, yearly
egen country_i = group(country_id_o)
egen country_j = group(country_id_d)

merge m:1 year using "geopol_index_means.dta"
drop if _merge == 2
drop if _merge == 1
save "gravity.dta", replace

gen lac_o = 0

replace lac_o = 1 if inlist(iso3_o, "ARG", "BOL", "BRA", "CHL", "COL")
replace lac_o = 1 if inlist(iso3_o, "CRI", "CUB", "DOM", "ECU", "SLV")
replace lac_o = 1 if inlist(iso3_o, "GTM", "HND", "MEX", "NIC", "PAN")
replace lac_o = 1 if inlist(iso3_o, "PRY", "PER", "URY", "VEN", "BLZ")
replace lac_o = 1 if inlist(iso3_o, "GUY", "SUR", "HTI")

gen lac_d = 0

replace lac_d = 1 if inlist(iso3_d, "ARG", "BOL", "BRA", "CHL", "COL")
replace lac_d = 1 if inlist(iso3_d, "CRI", "CUB", "DOM", "ECU", "SLV")
replace lac_d = 1 if inlist(iso3_d, "GTM", "HND", "MEX", "NIC", "PAN")
replace lac_d = 1 if inlist(iso3_d, "PRY", "PER", "URY", "VEN", "BLZ")
replace lac_d = 1 if inlist(iso3_d, "GUY", "SUR", "HTI")

gen lac_pair = lac_o == 1 | lac_d == 1
gen lac_both = lac_o == 1 & lac_d == 1

gen common_lac_pair = common * (lac_pair == 1)
gen common_lac_both = common * (lac_both == 1)

gen common_lac_pair_fta = common * (lac_pair == 1) * (fta_wto == 1)
gen common_lac_both_fta = common * (lac_both == 1) * (fta_wto == 1)

gen common_fta = common * (fta_wto == 1)

gen china_o = iso3_o == "CHN"
gen china_d = iso3_d == "CHN"

gen us_o = iso3_o == "USA"
gen us_d = iso3_d == "USA"

/*
0 = Rest of World
1 = Latin America
2 = China
3 = United States
4 = European Union
*/

gen bloc_o = 0
replace bloc_o = 1 if lac_o == 1
replace bloc_o = 2 if china_o == 1
replace bloc_o = 3 if us_o == 1
replace bloc_o = 4 if eu_o == 1

gen bloc_d = 0
replace bloc_d = 1 if lac_d == 1
replace bloc_d = 2 if china_d == 1
replace bloc_d = 3 if us_d == 1
replace bloc_d = 4 if eu_d == 1

label define bloclbl 0 "Rest of World" ///
                    1 "Latin America" ///
                    2 "China" ///
                    3 "United States" ///
                    4 "European Union"

label values bloc_o bloclbl
label values bloc_d bloclbl


gen bloc_pair = bloc_o * 10 + bloc_d

label define blocpairlbl ///
    0  "Rest to Rest" ///
    1  "Rest to LAC" ///
    2  "Rest to China" ///
    3  "Rest to US" ///
    4  "Rest to EU" ///
    10 "LAC to Rest" ///
    11 "LAC to LAC" ///
    12 "LAC to China" ///
    13 "LAC to US" ///
    14 "LAC to EU" ///
    20 "China to Rest" ///
    21 "China to LAC" ///
    22 "China to China" ///
    23 "China to US" ///
    24 "China to EU" ///
    30 "US to Rest" ///
    31 "US to LAC" ///
    32 "US to China" ///
    33 "US to US" ///
    34 "US to EU" ///
    40 "EU to Rest" ///
    41 "EU to LAC" ///
    42 "EU to China" ///
    43 "EU to US" ///
    44 "EU to EU"

label values bloc_pair blocpairlbl

fvset base 0 bloc_pair
ppmlhdfe tradeflow_baci ib0.bloc_pair##c.common, ///
    absorb(panel_id year) ///
    cluster(panel_id) d
	
coefplot, ///
    keep(10.bloc_pair#c.common ///
         11.bloc_pair#c.common ///
         12.bloc_pair#c.common ///
         13.bloc_pair#c.common ///
         14.bloc_pair#c.common ///
         21.bloc_pair#c.common ///
         31.bloc_pair#c.common ///
         41.bloc_pair#c.common) ///
    coeflabels( ///
        10.bloc_pair#c.common = "LAC → Rest" ///
        11.bloc_pair#c.common = "LAC → LAC" ///
        12.bloc_pair#c.common = "LAC → China" ///
        13.bloc_pair#c.common = "LAC → US" ///
        14.bloc_pair#c.common = "LAC → EU" ///
        21.bloc_pair#c.common = "China → LAC" ///
        31.bloc_pair#c.common = "US → LAC" ///
        41.bloc_pair#c.common = "EU → LAC" ///
    ) ///
    vertical ///
    yline(0, lpattern(dash)) ///
    xlabel(, angle(45) labsize(small)) ///
    xtitle("") ///
    ytitle("") ///
    title("PPML interaction estimates") ///
    name(common_lac_interactions, replace)
	
graph export "coef.eps", replace
	
//Table 2
clear all
cd "C:/Users/maxit/OneDrive/Escritorio/UW/FLAR/Data"
import delimited GeopoliticalFragmentationIndex.csv
collapse (mean) common trade financial mobility political ///
    useublocfragmentation chinarussiablocfragmentation othersblocfragmentation, by(year)
	
save "geopol_index_means.dta", replace

use "C:\Users\maxit\Downloads\Gravity_dta_V202211\Gravity_V202211.dta" 
egen panel_id = group(country_id_o country_id_d)
xtset panel_id year, yearly
egen country_i = group(country_id_o)
egen country_j = group(country_id_d)

merge m:1 year using "geopol_index_means.dta"
drop if _merge == 2
drop if _merge == 1
save "gravity.dta", replace

gen lac_o = 0

replace lac_o = 1 if inlist(iso3_o, "ARG", "BOL", "BRA", "CHL", "COL")
replace lac_o = 1 if inlist(iso3_o, "CRI", "CUB", "DOM", "ECU", "SLV")
replace lac_o = 1 if inlist(iso3_o, "GTM", "HND", "MEX", "NIC", "PAN")
replace lac_o = 1 if inlist(iso3_o, "PRY", "PER", "URY", "VEN", "BLZ")
replace lac_o = 1 if inlist(iso3_o, "GUY", "SUR", "HTI")

gen lac_d = 0

replace lac_d = 1 if inlist(iso3_d, "ARG", "BOL", "BRA", "CHL", "COL")
replace lac_d = 1 if inlist(iso3_d, "CRI", "CUB", "DOM", "ECU", "SLV")
replace lac_d = 1 if inlist(iso3_d, "GTM", "HND", "MEX", "NIC", "PAN")
replace lac_d = 1 if inlist(iso3_d, "PRY", "PER", "URY", "VEN", "BLZ")
replace lac_d = 1 if inlist(iso3_d, "GUY", "SUR", "HTI")

gen lac_pair = lac_o == 1 | lac_d == 1
gen lac_both = lac_o == 1 & lac_d == 1

gen common_lac_pair = common * (lac_pair == 1)
gen common_lac_both = common * (lac_both == 1)

gen common_lac_pair_fta = common * (lac_pair == 1) * (fta_wto == 1)
gen common_lac_both_fta = common * (lac_both == 1) * (fta_wto == 1)

gen common_fta = common * (fta_wto == 1)

gen pair_type = .
replace pair_type = 0 if lac_o == 0 & lac_d == 0
replace pair_type = 1 if lac_o == 1 & lac_d == 1
replace pair_type = 2 if lac_o == 1 & lac_d == 0
replace pair_type = 3 if lac_o == 0 & lac_d == 1

label define pairtype 0 "Non-LAC to Non-LAC" ///
                      1 "LAC to LAC" ///
                      2 "LAC to Non-LAC" ///
                      3 "Non-LAC to LAC"
label values pair_type pairtype

gen common_lac_lac = common * (pair_type == 1) 
gen common_lac_nonlac = common * (pair_type == 2)
gen common_nonlac_lac = common * (pair_type == 3)

gen common_lac_lac_fta = common * (pair_type == 1) * (fta_wto == 1)
gen common_lac_nonlac_fta = common * (pair_type == 2) * (fta_wto == 1)
gen common_nonlac_lac_fta = common * (pair_type == 3) * (fta_wto == 1)


gen vuln_o = 0
gen vuln_d = 0

replace vuln_o = 1 if inlist(iso3_o, "CHL", "BOL", "CRI", "MEX", "PRY", "VEN")
replace vuln_d = 1 if inlist(iso3_d, "CHL", "BOL", "CRI", "MEX", "PRY", "VEN")

label define vuln_lbl 0 "Less vulnerable / non-vulnerable" ///
                      1 "More vulnerable"
label values vuln_o vuln_lbl
label values vuln_d vuln_lbl

gen vuln_lac_pair = (vuln_o == 1 | vuln_d == 1)

gen lessvuln_lac_pair = (lac_pair == 1 & vuln_lac_pair == 0)

gen vuln_lac_lac = (pair_type == 1 & vuln_lac_pair == 1)

gen lessvuln_lac_lac = (pair_type == 1 & vuln_lac_pair == 0)

gen vuln_lac_nonlac = (pair_type == 2 & vuln_o == 1)
gen lessvuln_lac_nonlac = (pair_type == 2 & vuln_o == 0)

gen nonlac_vuln_lac = (pair_type == 3 & vuln_d == 1)
gen nonlac_lessvuln_lac = (pair_type == 3 & vuln_d == 0)

gen common_vuln_lac_pair = common * vuln_lac_pair
gen common_lessvuln_lac_pair = common * lessvuln_lac_pair

gen common_vuln_lac_lac = common * vuln_lac_lac
gen common_lessvuln_lac_lac = common * lessvuln_lac_lac

gen common_vuln_lac_nonlac = common * vuln_lac_nonlac
gen common_lessvuln_lac_nonlac = common * lessvuln_lac_nonlac

gen common_nonlac_vuln_lac = common * nonlac_vuln_lac
gen common_nonlac_lessvuln_lac = common * nonlac_lessvuln_lac

gen common_vuln_lac_lac_fta = common * vuln_lac_lac * (fta_wto == 1)
gen common_lessvuln_lac_lac_fta = common * lessvuln_lac_lac * (fta_wto == 1)

gen common_vuln_lac_nonlac_fta = common * vuln_lac_nonlac * (fta_wto == 1)
gen common_lessvuln_lac_nonlac_fta = common * lessvuln_lac_nonlac * (fta_wto == 1)

gen common_nonlac_vuln_lac_fta = common * nonlac_vuln_lac * (fta_wto == 1)
gen common_nonlac_lessvuln_lac_fta = common * nonlac_lessvuln_lac * (fta_wto == 1)

eststo clear

eststo m1: ppmlhdfe tradeflow_baci ///
    common_vuln_lac_lac ///
    common_lessvuln_lac_lac, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

eststo m2: ppmlhdfe tradeflow_baci ///
    common_vuln_lac_lac ///
    common_lessvuln_lac_lac ///
    common_vuln_lac_nonlac ///
    common_lessvuln_lac_nonlac ///
    common_nonlac_vuln_lac ///
    common_nonlac_lessvuln_lac, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

eststo m3: ppmlhdfe tradeflow_baci ///
    common_vuln_lac_lac ///
    common_lessvuln_lac_lac ///
    common_vuln_lac_lac_fta ///
    common_lessvuln_lac_lac_fta ///
    common_fta, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

eststo m4: ppmlhdfe tradeflow_baci ///
    common_vuln_lac_lac ///
    common_lessvuln_lac_lac ///
    common_vuln_lac_nonlac ///
    common_lessvuln_lac_nonlac ///
    common_nonlac_vuln_lac ///
    common_nonlac_lessvuln_lac ///
    common_vuln_lac_lac_fta ///
    common_lessvuln_lac_lac_fta ///
    common_vuln_lac_nonlac_fta ///
    common_lessvuln_lac_nonlac_fta ///
    common_nonlac_vuln_lac_fta ///
    common_nonlac_lessvuln_lac_fta ///
    common_fta, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

esttab m1 m2 m3 m4 using "ppml_results_vulnerability_to.tex", replace ///
    tex ///
    se ///
    b(3) se(3) ///
    nomtitles ///
    drop(_cons, relax) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    coeflabels( ///
        common_vuln_lac_lac               "GFI_t × Vulnerable LAC intraregion" ///
        common_lessvuln_lac_lac           "GFI_t × Less vulnerable LAC intraregion" ///
        common_vuln_lac_nonlac            "GFI_t × Vulnerable LAC exporter" ///
        common_lessvuln_lac_nonlac        "GFI_t × Less vulnerable LAC exporter" ///
        common_nonlac_vuln_lac            "GFI_t × Vulnerable LAC importer" ///
        common_nonlac_lessvuln_lac        "GFI_t × Less vulnerable LAC importer" ///
        common_vuln_lac_lac_fta           "GFI_t × Vulnerable LAC intraregion × FTA" ///
        common_lessvuln_lac_lac_fta       "GFI_t × Less vulnerable LAC intraregion × FTA" ///
        common_vuln_lac_nonlac_fta        "GFI_t × Vulnerable LAC exporter × FTA" ///
        common_lessvuln_lac_nonlac_fta    "GFI_t × Less vulnerable LAC exporter × FTA" ///
        common_nonlac_vuln_lac_fta        "GFI_t × Vulnerable LAC importer × FTA" ///
        common_nonlac_lessvuln_lac_fta    "GFI_t × Less vulnerable LAC importer × FTA" ///
        common_fta                        "GFI_t × FTA" ///
    ) ///
    stats(N clusters pseudo_r2 pair_fe year_fe, ///
        labels("Observations" ///
               "Country-pair clusters" ///
               "Pseudo R-squared" ///
               "Pair FE" ///
               "Year FE") ///
        fmt(0 0 3 s s)) ///
    title("PPML Estimates by Trade Openness Vulnerability") ///
    addnotes("Cluster-robust standard errors are clustered at the country-pair level." ///
             "Pair and year fixed effects are included in all specifications. Constants are not reported." ///
             "Vulnerable countries are those with below-median average Trade Openness in the FLAR sample.") ///
    compress	
	
//Table 3
clear all
cd "C:/Users/maxit/OneDrive/Escritorio/UW/FLAR/Data"
import delimited GeopoliticalFragmentationIndex.csv
collapse (mean) common trade financial mobility political ///
    useublocfragmentation chinarussiablocfragmentation othersblocfragmentation, by(year)
	
save "geopol_index_means.dta", replace

use "C:\Users\maxit\Downloads\Gravity_dta_V202211\Gravity_V202211.dta" 
egen panel_id = group(country_id_o country_id_d)
xtset panel_id year, yearly
egen country_i = group(country_id_o)
egen country_j = group(country_id_d)

merge m:1 year using "geopol_index_means.dta"
drop if _merge == 2
drop if _merge == 1
save "gravity.dta", replace

gen lac_o = 0

replace lac_o = 1 if inlist(iso3_o, "ARG", "BOL", "BRA", "CHL", "COL")
replace lac_o = 1 if inlist(iso3_o, "CRI", "CUB", "DOM", "ECU", "SLV")
replace lac_o = 1 if inlist(iso3_o, "GTM", "HND", "MEX", "NIC", "PAN")
replace lac_o = 1 if inlist(iso3_o, "PRY", "PER", "URY", "VEN", "BLZ")
replace lac_o = 1 if inlist(iso3_o, "GUY", "SUR", "HTI")

gen lac_d = 0

replace lac_d = 1 if inlist(iso3_d, "ARG", "BOL", "BRA", "CHL", "COL")
replace lac_d = 1 if inlist(iso3_d, "CRI", "CUB", "DOM", "ECU", "SLV")
replace lac_d = 1 if inlist(iso3_d, "GTM", "HND", "MEX", "NIC", "PAN")
replace lac_d = 1 if inlist(iso3_d, "PRY", "PER", "URY", "VEN", "BLZ")
replace lac_d = 1 if inlist(iso3_d, "GUY", "SUR", "HTI")

gen lac_pair = lac_o == 1 | lac_d == 1
gen lac_both = lac_o == 1 & lac_d == 1

gen common_lac_pair = common * (lac_pair == 1)
gen common_lac_both = common * (lac_both == 1)

gen common_lac_pair_fta = common * (lac_pair == 1) * (fta_wto == 1)
gen common_lac_both_fta = common * (lac_both == 1) * (fta_wto == 1)

gen common_fta = common * (fta_wto == 1)

gen pair_type = .
replace pair_type = 0 if lac_o == 0 & lac_d == 0
replace pair_type = 1 if lac_o == 1 & lac_d == 1
replace pair_type = 2 if lac_o == 1 & lac_d == 0
replace pair_type = 3 if lac_o == 0 & lac_d == 1

label define pairtype 0 "Non-LAC to Non-LAC" ///
                      1 "LAC to LAC" ///
                      2 "LAC to Non-LAC" ///
                      3 "Non-LAC to LAC"
label values pair_type pairtype

gen common_lac_lac = common * (pair_type == 1) 
gen common_lac_nonlac = common * (pair_type == 2)
gen common_nonlac_lac = common * (pair_type == 3)

gen common_lac_lac_fta = common * (pair_type == 1) * (fta_wto == 1)
gen common_lac_nonlac_fta = common * (pair_type == 2) * (fta_wto == 1)
gen common_nonlac_lac_fta = common * (pair_type == 3) * (fta_wto == 1)


gen vuln_o = 0
gen vuln_d = 0

replace vuln_o = 1 if inlist(iso3_o, "CHL", "ECU", "MEX", "PRY")
replace vuln_d = 1 if inlist(iso3_d, "CHL", "ECU", "MEX", "PRY")

label define vuln_lbl 0 "Less vulnerable / non-vulnerable" ///
                      1 "More vulnerable"
label values vuln_o vuln_lbl
label values vuln_d vuln_lbl

gen vuln_lac_pair = (vuln_o == 1 | vuln_d == 1)

gen lessvuln_lac_pair = (lac_pair == 1 & vuln_lac_pair == 0)

gen vuln_lac_lac = (pair_type == 1 & vuln_lac_pair == 1)

gen lessvuln_lac_lac = (pair_type == 1 & vuln_lac_pair == 0)

gen vuln_lac_nonlac = (pair_type == 2 & vuln_o == 1)
gen lessvuln_lac_nonlac = (pair_type == 2 & vuln_o == 0)

gen nonlac_vuln_lac = (pair_type == 3 & vuln_d == 1)
gen nonlac_lessvuln_lac = (pair_type == 3 & vuln_d == 0)

gen common_vuln_lac_pair = common * vuln_lac_pair
gen common_lessvuln_lac_pair = common * lessvuln_lac_pair

gen common_vuln_lac_lac = common * vuln_lac_lac
gen common_lessvuln_lac_lac = common * lessvuln_lac_lac

gen common_vuln_lac_nonlac = common * vuln_lac_nonlac
gen common_lessvuln_lac_nonlac = common * lessvuln_lac_nonlac

gen common_nonlac_vuln_lac = common * nonlac_vuln_lac
gen common_nonlac_lessvuln_lac = common * nonlac_lessvuln_lac

gen common_vuln_lac_lac_fta = common * vuln_lac_lac * (fta_wto == 1)
gen common_lessvuln_lac_lac_fta = common * lessvuln_lac_lac * (fta_wto == 1)

gen common_vuln_lac_nonlac_fta = common * vuln_lac_nonlac * (fta_wto == 1)
gen common_lessvuln_lac_nonlac_fta = common * lessvuln_lac_nonlac * (fta_wto == 1)

gen common_nonlac_vuln_lac_fta = common * nonlac_vuln_lac * (fta_wto == 1)
gen common_nonlac_lessvuln_lac_fta = common * nonlac_lessvuln_lac * (fta_wto == 1)

eststo clear

eststo m1: ppmlhdfe tradeflow_baci ///
    common_vuln_lac_lac ///
    common_lessvuln_lac_lac, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

eststo m2: ppmlhdfe tradeflow_baci ///
    common_vuln_lac_lac ///
    common_lessvuln_lac_lac ///
    common_vuln_lac_nonlac ///
    common_lessvuln_lac_nonlac ///
    common_nonlac_vuln_lac ///
    common_nonlac_lessvuln_lac, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

eststo m3: ppmlhdfe tradeflow_baci ///
    common_vuln_lac_lac ///
    common_lessvuln_lac_lac ///
    common_vuln_lac_lac_fta ///
    common_lessvuln_lac_lac_fta ///
    common_fta, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

eststo m4: ppmlhdfe tradeflow_baci ///
    common_vuln_lac_lac ///
    common_lessvuln_lac_lac ///
    common_vuln_lac_nonlac ///
    common_lessvuln_lac_nonlac ///
    common_nonlac_vuln_lac ///
    common_nonlac_lessvuln_lac ///
    common_vuln_lac_lac_fta ///
    common_lessvuln_lac_lac_fta ///
    common_vuln_lac_nonlac_fta ///
    common_lessvuln_lac_nonlac_fta ///
    common_nonlac_vuln_lac_fta ///
    common_nonlac_lessvuln_lac_fta ///
    common_fta, ///
    absorb(panel_id year) ///
    cluster(panel_id) nocons

estadd local pair_fe "Yes"
estadd local year_fe "Yes"
estadd scalar clusters = e(N_clust)
estadd scalar pseudo_r2 = e(r2_p)

esttab m1 m2 m3 m4 using "ppml_results_vulnerability_tot.tex", replace ///
    tex ///
    se ///
    b(3) se(3) ///
    nomtitles ///
    drop(_cons, relax) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    coeflabels( ///
        common_vuln_lac_lac               "GFI_t × Vulnerable LAC intraregion" ///
        common_lessvuln_lac_lac           "GFI_t × Less vulnerable LAC intraregion" ///
        common_vuln_lac_nonlac            "GFI_t × Vulnerable LAC exporter" ///
        common_lessvuln_lac_nonlac        "GFI_t × Less vulnerable LAC exporter" ///
        common_nonlac_vuln_lac            "GFI_t × Vulnerable LAC importer" ///
        common_nonlac_lessvuln_lac        "GFI_t × Less vulnerable LAC importer" ///
        common_vuln_lac_lac_fta           "GFI_t × Vulnerable LAC intraregion × FTA" ///
        common_lessvuln_lac_lac_fta       "GFI_t × Less vulnerable LAC intraregion × FTA" ///
        common_vuln_lac_nonlac_fta        "GFI_t × Vulnerable LAC exporter × FTA" ///
        common_lessvuln_lac_nonlac_fta    "GFI_t × Less vulnerable LAC exporter × FTA" ///
        common_nonlac_vuln_lac_fta        "GFI_t × Vulnerable LAC importer × FTA" ///
        common_nonlac_lessvuln_lac_fta    "GFI_t × Less vulnerable LAC importer × FTA" ///
        common_fta                        "GFI_t × FTA" ///
    ) ///
    stats(N clusters pseudo_r2 pair_fe year_fe, ///
        labels("Observations" ///
               "Country-pair clusters" ///
               "Pseudo R-squared" ///
               "Pair FE" ///
               "Year FE") ///
        fmt(0 0 3 s s)) ///
    title("PPML Estimates by Terms-of-Trade Vulnerability") ///
    addnotes("Cluster-robust standard errors are clustered at the country-pair level." ///
             "Pair and year fixed effects are included in all specifications. Constants are not reported." ///
             "Vulnerable countries are those with below-median average Terms of Trade in the FLAR sample.") ///
    compress
	
	
//Bayesian extension

clear all
set more off
set seed 12345

cap which reghdfe
if _rc ssc install reghdfe, replace

cap which ftools
if _rc ssc install ftools, replace

global DATA "C:/Users/maxit/OneDrive/Escritorio/UW/FLAR/Data"
global GRAV "C:/Users/maxit/Downloads/Gravity_dta_V202211"
global OUT  "C:/Users/maxit/OneDrive/Escritorio/UW/FLAR/Data"

cd "$DATA"

import delimited "GeopoliticalFragmentationIndex.csv", clear

collapse (mean) common trade financial mobility political ///
    useublocfragmentation chinarussiablocfragmentation ///
    othersblocfragmentation, by(year)

save "geopol_index_means.dta", replace


use "$GRAV/Gravity_V202211.dta", clear

egen panel_id = group(country_id_o country_id_d)
egen country_i = group(country_id_o)
egen country_j = group(country_id_d)

merge m:1 year using "$DATA/geopol_index_means.dta"
drop if _merge == 2
drop if _merge == 1
drop _merge

xtset panel_id year, yearly

save "$DATA/gravity.dta", replace


gen lac_o = 0

replace lac_o = 1 if inlist(iso3_o, "ARG", "BOL", "BRA", "CHL", "COL")
replace lac_o = 1 if inlist(iso3_o, "CRI", "CUB", "DOM", "ECU", "SLV")
replace lac_o = 1 if inlist(iso3_o, "GTM", "HND", "MEX", "NIC", "PAN")
replace lac_o = 1 if inlist(iso3_o, "PRY", "PER", "URY", "VEN", "BLZ")
replace lac_o = 1 if inlist(iso3_o, "GUY", "SUR", "HTI")

gen lac_d = 0

replace lac_d = 1 if inlist(iso3_d, "ARG", "BOL", "BRA", "CHL", "COL")
replace lac_d = 1 if inlist(iso3_d, "CRI", "CUB", "DOM", "ECU", "SLV")
replace lac_d = 1 if inlist(iso3_d, "GTM", "HND", "MEX", "NIC", "PAN")
replace lac_d = 1 if inlist(iso3_d, "PRY", "PER", "URY", "VEN", "BLZ")
replace lac_d = 1 if inlist(iso3_d, "GUY", "SUR", "HTI")

gen lac_pair = lac_o == 1 | lac_d == 1
gen lac_both = lac_o == 1 & lac_d == 1

gen common_lac_pair = common * (lac_pair == 1)
gen common_lac_both = common * (lac_both == 1)

gen common_lac_pair_fta = common * (lac_pair == 1) * (fta_wto == 1)
gen common_lac_both_fta = common * (lac_both == 1) * (fta_wto == 1)

gen common_fta = common * (fta_wto == 1)

gen pair_type = .
replace pair_type = 0 if lac_o == 0 & lac_d == 0
replace pair_type = 1 if lac_o == 1 & lac_d == 1
replace pair_type = 2 if lac_o == 1 & lac_d == 0
replace pair_type = 3 if lac_o == 0 & lac_d == 1

label define pairtype 0 "Non-LAC to Non-LAC" ///
                      1 "LAC to LAC" ///
                      2 "LAC to Non-LAC" ///
                      3 "Non-LAC to LAC"

label values pair_type pairtype

gen common_lac_lac = common * (pair_type == 1)
gen common_lac_nonlac = common * (pair_type == 2)
gen common_nonlac_lac = common * (pair_type == 3)

gen common_lac_lac_fta = common * (pair_type == 1) * (fta_wto == 1)
gen common_lac_nonlac_fta = common * (pair_type == 2) * (fta_wto == 1)
gen common_nonlac_lac_fta = common * (pair_type == 3) * (fta_wto == 1)

set more off
set seed 12345

xtset panel_id year, yearly

gen double ln_trade = ln(1 + tradeflow_baci)
gen double L_ln_trade = L.ln_trade

keep panel_id year ln_trade L_ln_trade ///
    common_lac_lac common_lac_nonlac common_nonlac_lac ///
    common_lac_lac_fta common_lac_nonlac_fta ///
    common_nonlac_lac_fta common_fta

egen miss = rowmiss(ln_trade L_ln_trade ///
    common_lac_lac common_lac_nonlac common_nonlac_lac ///
    common_lac_lac_fta common_lac_nonlac_fta ///
    common_nonlac_lac_fta common_fta)

drop if miss > 0
drop miss

cap mkdir "$OUT/bayes_m5_fast"
local diagdir "$OUT/bayes_m5_fast"


foreach v in ln_trade L_ln_trade ///
    common_lac_lac common_lac_nonlac common_nonlac_lac ///
    common_lac_lac_fta common_lac_nonlac_fta ///
    common_nonlac_lac_fta common_fta {

    cap drop r_`v'
    quietly reghdfe `v', absorb(panel_id year) residuals(r_`v')
}

keep r_ln_trade r_L_ln_trade ///
    r_common_lac_lac r_common_lac_nonlac r_common_nonlac_lac ///
    r_common_lac_lac_fta r_common_lac_nonlac_fta ///
    r_common_nonlac_lac_fta r_common_fta

compress

mata:

real scalar vmean(real colvector x)
{
    return(colsum(x) / rows(x))
}

real scalar vsd(real colvector x)
{
    real scalar m
    m = vmean(x)
    return(sqrt(quadcross(x :- m, x :- m) / (rows(x) - 1)))
}

real scalar qtile(real colvector x, real scalar p)
{
    real scalar n, h, j, g

    x = sort(x, 1)
    n = rows(x)

    if (n == 1) return(x[1])

    h = 1 + (n - 1) * p
    j = floor(h)
    g = h - j

    if (j >= n) return(x[n])

    return((1 - g) * x[j] + g * x[j + 1])
}

real scalar acf_lag(real colvector x, real scalar L)
{
    real scalar n, m, denom

    n = rows(x)
    m = vmean(x)

    denom = quadcross(x :- m, x :- m)

    if (denom <= 0) return(0)

    return(quadcross(x[|1 \ n-L|] :- m, x[|1+L \ n|] :- m) / denom)
}

real scalar quick_ess(real colvector x, real scalar maxlag)
{
    real scalar n, L, rho, sumrho

    n = rows(x)
    sumrho = 0

    for (L = 1; L <= min((n - 1, maxlag)); L++) {

        rho = acf_lag(x, L)

        if (rho <= 0) break

        sumrho = sumrho + rho
    }

    return(n / (1 + 2 * sumrho))
}

void write_summary_line(
    real scalar fh,
    string scalar model,
    string scalar parameter,
    string scalar effect_type,
    real colvector x
)
{
    fput(fh, sprintf(
        "%s,%s,%s,%9.6f,%9.6f,%9.6f,%9.6f,%9.6f",
        model,
        parameter,
        effect_type,
        vmean(x),
        vsd(x),
        qtile(x, 0.025),
        qtile(x, 0.975),
        colsum(x :> 0) / rows(x)
    ))
}

void bayes_m5_fast(
    string scalar outdraws,
    string scalar outsummary,
    string scalar outdiag
)
{
    real colvector y, theta, mn, z, res, lr
    real matrix X, XtX, Xty, V0inv, Vn, C, all
    real scalar n, k
    real scalar ndraws, burnin, thin, total, keep, nchains
    real scalar a0, b0, an, bn, sigma2
    real scalar s, c, counter, row, j, fh
    real scalar W, B, varplus, rhat, ess, mcse
    real colvector x, xc, chainmeans, chainvars
    string scalar xvars, line, pname
    string rowvector names

    xvars = "r_L_ln_trade " +
            "r_common_lac_lac r_common_lac_nonlac r_common_nonlac_lac " +
            "r_common_lac_lac_fta r_common_lac_nonlac_fta " +
            "r_common_nonlac_lac_fta r_common_fta"

    st_view(y = ., ., "r_ln_trade")
    st_view(X = ., ., tokens(xvars))

    names = tokens(
        "rho " +
        "common_lac_lac common_lac_nonlac common_nonlac_lac " +
        "common_lac_lac_fta common_lac_nonlac_fta " +
        "common_nonlac_lac_fta common_fta"
    )

    n = rows(y)
    k = cols(X)

    ndraws  = 2000
    burnin  = 500
    thin    = 1
    nchains = 2

    total = burnin + ndraws
    keep  = floor(ndraws / thin)

    /*
      Priors:
      theta | sigma2 ~ N(0, 100 sigma2 I)
      sigma2 ~ IG(2, 1)
    */

    V0inv = I(k) / 100
    XtX   = quadcross(X, X)
    Xty   = quadcross(X, y)

    Vn = invsym(XtX + V0inv)
    mn = Vn * Xty
    C  = cholesky(Vn)

    a0 = 2
    b0 = 1

    all = J(keep * nchains, k + 3, .)
    fh = fopen(outdraws, "w")

    line = "chain,draw"

    for (j = 1; j <= k; j++) {
        line = line + "," + names[j]
    }

    line = line + ",sigma2"
    fput(fh, line)

    row = 0

    for (c = 1; c <= nchains; c++) {

        sigma2 = quadcross(y :- vmean(y), y :- vmean(y)) / n
        sigma2 = sigma2 * (0.85 + 0.15 * c)

        counter = 0

        for (s = 1; s <= total; s++) {

            z = rnormal(k, 1, 0, 1)

            theta = mn + sqrt(sigma2) * C * z

            res = y - X * theta

            an = a0 + n / 2
            bn = b0 + quadcross(res, res) / 2

            sigma2 = 1 / rgamma(1, 1, an, 1 / bn)

            if (s > burnin & mod(s - burnin, thin) == 0) {

                counter = counter + 1
                row = row + 1

                all[row, 1] = c
                all[row, 2] = counter

                for (j = 1; j <= k; j++) {
                    all[row, j + 2] = theta[j]
                }

                all[row, k + 3] = sigma2

                line = sprintf("%f,%f", c, counter)

                for (j = 1; j <= k; j++) {
                    line = line + sprintf(",%9.6f", theta[j])
                }

                line = line + sprintf(",%9.6f", sigma2)

                fput(fh, line)
            }
        }
    }

    fclose(fh)


    fh = fopen(outsummary, "w")
    fput(fh, "model,parameter,effect_type,mean,sd,p025,p975,pr_gt_zero")

    for (j = 1; j <= k; j++) {
        write_summary_line(
            fh,
            "m5",
            names[j],
            "short_run",
            all[, j + 2]
        )
    }

    for (j = 2; j <= k; j++) {

        lr = select(
            all[, j + 2] :/ (1 :- all[, 3]),
            abs(all[, 3]) :< 0.99
        )

        write_summary_line(
            fh,
            "m5",
            "LR_" + names[j],
            "long_run",
            lr
        )
    }

    fclose(fh)


    fh = fopen(outdiag, "w")
    fput(fh, "parameter,mean,sd,p025,p975,pr_gt_zero,rhat,ess_approx,mcse")

    for (j = 1; j <= k + 1; j++) {

        if (j <= k) {
            pname = names[j]
        }
        else {
            pname = "sigma2"
        }

        x = all[, j + 2]

        chainmeans = J(nchains, 1, .)
        chainvars  = J(nchains, 1, .)

        ess = 0

        for (c = 1; c <= nchains; c++) {

            xc = select(x, all[, 1] :== c)

            chainmeans[c] = vmean(xc)
            chainvars[c]  = vsd(xc)^2

            /*
              Approximate ESS:
              only 20 autocorrelation lags to keep it fast.
            */

            ess = ess + quick_ess(xc, 20)
        }

        W = vmean(chainvars)

        B = keep * quadcross(
            chainmeans :- vmean(chainmeans),
            chainmeans :- vmean(chainmeans)
        ) / (nchains - 1)

        varplus = ((keep - 1) / keep) * W + B / keep

        rhat = sqrt(varplus / W)

        mcse = vsd(x) / sqrt(ess)

        fput(fh, sprintf(
            "%s,%9.6f,%9.6f,%9.6f,%9.6f,%9.6f,%9.6f,%9.2f,%9.6f",
            pname,
            vmean(x),
            vsd(x),
            qtile(x, 0.025),
            qtile(x, 0.975),
            colsum(x :> 0) / rows(x),
            rhat,
            ess,
            mcse
        ))
    }

    fclose(fh)

    printf("\nBayesian Dynamic Gravity Model - m5\n")
    printf("Sampler: Gibbs sampler\n")
    printf("Chains: %f\n", nchains)
    printf("Burn-in per chain: %f\n", burnin)
    printf("Retained draws per chain: %f\n", keep)
    printf("Total retained posterior draws: %f\n", keep * nchains)
    printf("\n")

    printf("Short-run posterior effects\n")
    printf("-------------------------------------------------------------\n")
    printf("%-30s %10s %10s %10s %10s %10s\n",
        "parameter", "mean", "sd", "p025", "p975", "Pr>0")

    for (j = 1; j <= k; j++) {
        printf("%-30s %10.4f %10.4f %10.4f %10.4f %10.3f\n",
            names[j],
            vmean(all[, j + 2]),
            vsd(all[, j + 2]),
            qtile(all[, j + 2], 0.025),
            qtile(all[, j + 2], 0.975),
            colsum(all[, j + 2] :> 0) / rows(all))
    }

    printf("\nLong-run posterior effects: beta / (1 - rho)\n")
    printf("-------------------------------------------------------------\n")
    printf("%-30s %10s %10s %10s %10s %10s\n",
        "parameter", "mean", "sd", "p025", "p975", "Pr>0")

    for (j = 2; j <= k; j++) {

        lr = select(
            all[, j + 2] :/ (1 :- all[, 3]),
            abs(all[, 3]) :< 0.99
        )

        printf("%-30s %10.4f %10.4f %10.4f %10.4f %10.3f\n",
            "LR_" + names[j],
            vmean(lr),
            vsd(lr),
            qtile(lr, 0.025),
            qtile(lr, 0.975),
            colsum(lr :> 0) / rows(lr))
    }
}

bayes_m5(
    "`diagdir'/m5_draws.csv",
    "`diagdir'/m5_posterior_summary.csv",
    "`diagdir'/m5_fast_diagnostics.csv"
)

end

import delimited "`diagdir'/m5_posterior_summary.csv", clear

order model parameter effect_type mean sd p025 p975 pr_gt_zero

export excel using "`diagdir'/m5_posterior_summary.xlsx", ///
    firstrow(variables) replace

import delimited "`diagdir'/m5_fast_diagnostics.csv", clear

order parameter mean sd p025 p975 pr_gt_zero rhat ess_approx mcse

export excel using "`diagdir'/m5_fast_diagnostics.xlsx", ///
    firstrow(variables) replace

list, sep(0)

import delimited "`diagdir'/m5_draws.csv", clear

local key_params ///
    rho ///
    common_lac_lac ///
    common_lac_nonlac_fta

foreach p of local key_params {

    twoway ///
        (line `p' draw if chain == 1, sort) ///
        (line `p' draw if chain == 2, sort), ///
        title("Trace plot: `p'") ///
        xtitle("Posterior draw") ///
        ytitle("Parameter value") ///
        legend(order(1 "Chain 1" 2 "Chain 2"))

    graph export "`diagdir'/trace_`p'.png", replace
}
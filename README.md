# PaySim-FinTech-Fraud-Analytics-Detection-Monitoring-Dashboard
Tools: Excel / Power Query  →  PostgreSQL  →  Power BI Dataset: PaySim — synthetic mobile money transaction data modeled on real financial logs

## Project Overview 
This project analyzes transaction and fraud data from the PaySim dataset to evaluate how well an existing fraud-flagging system is performing and where a monitoring team should focus its attention. Data was cleaned and modeled in PostgreSQL, queried with SQL to answer a structured set of business questions, and visualized in a 3-page Power BI dashboard:
1. Executive Overview – overall transaction performance and risk distribution
2. Fraud & Risk Monitoring - effectiveness of the current fraud-flagging mechanism
3. Behavior & Transaction Pattern – the transaction patterns fraud actually follows

## Business Challenge 
Digital and mobile money platforms process huge transaction volumes, and fraud even when statistically rare,  can carry outsized financial impact. The organization needed to know:

▪️ How much fraud is actually happening, and how much money is at risk

▪️ Whether the current automated fraud-flagging system is actually catching it

▪️ Which transaction types, value ranges, and accounts carry the greatest risk

The goal was to turn raw transaction logs into a monitoring tool that management could use to prioritize investigation and control effort, rather than treating fraud detection as a black box.

## Business Questions 
#### Executive Overview 

▪️ How is the transaction performance and transaction risk distribution?
#### Fraud & Risk Monitoring 

▪️ How effective is the existing fraud mechanism?

▪️ Where should management focus on monitoring?
#### Behavior & Transaction pattern

▪️ What transaction pattern is associated with fraud?

▪️ Are there accounts associated with repeated fraud?

## Action: Data Preparation, Transformation, Modeling & Visualization
#### Data preparation (Excel/Power query)

▪️ Initial inspection and cleaning of the raw PaySim export prior to loading
#### Transformation and Modelling 

▪️ Loaded cleaned data into a structured transactions table (step, transaction type, amount, origin/destination accounts and balances, fraud flags)

▪️ Analytical field were engineered   directly in the model: Amount_band (Low/Medium/High/Very high), Fraud_status, Fraud_flagged_status, Origin_balance_change, Destination_balance_change, and Hour_of_day (derived from step)

▪️ Wrote a structured SQL analysis script covering:

I. Volume and value breakdowns by transaction type (with window functions for percentage-of-total)

ii. Fraud rate and fraud value overall and by transaction type

iii. Detection effectiveness (is_fraud vs. is_flagged) to quantify flagged vs. unflagged fraud

iv. Amount-band fraud concentration

v. Repeat-offender account detection (HAVING count(*) > 1 on fraudulent transactions per origin account).

<img width="554" height="468" alt="sql_script_screenshot" src="https://github.com/user-attachments/assets/83f86316-c78a-4eab-9c07-bf6d8c24938f" />

## Visualization (PowerBI)

▪️ Connected Power BI to the modeled PostgreSQL tables

▪️ Three linked dashboard pages was built with slicers on Fraud_status, Amount_band, step, and Transaction_type so a user can drill from headline KPIs down to individual flagged accounts.

## Dashboard Overview
<img width="783" height="440" alt="Executive_overview" src="https://github.com/user-attachments/assets/a2c143ae-fd32-4d05-a088-868c44496e98" />

<img width="771" height="430" alt="Fraud_management" src="https://github.com/user-attachments/assets/caa641b1-3bd2-4d51-8971-fa9dbfd6df1b" />

<img width="761" height="428" alt="Behavior_transaction_pattern" src="https://github.com/user-attachments/assets/e648931d-2651-4fa2-bd1d-e2b99a7afcce" />

## Key Insights 
Note on scope: The Executive Overview and Fraud & Risk Monitoring pages reflect the full dataset (932 fraudulent transactions, 1.37bn fraud value). The Behavior & Transaction Pattern page is filtered to the "High" Amount_band slicer, so its totals (539 fraudulent transactions, 1.32bn fraud value, 103K accounts) describe that filtered slice only — they are not directly comparable to the full-dataset figures above.
1. Scale: ~707K total transactions worth 127.05bn, averaging 179.72K per transaction.
2. Fraud is rare but costly: Only 932 transactions (0.13%) were fraudulent, yet they carried 1.37bn in value — fraud transactions run far larger than the average legitimate one.
3. Fraud is fully concentrated in two channels: Every fraudulent transaction occurred in Transfer or Cash_Out — no fraud appeared in Payment, Cash_In, or Debit transactions.
4. The flagging system is barely functioning: Of 932 fraudulent transactions, only 1 was flagged by the existing system — a 0.11% detection rate. 931 fraudulent transactions (1.37bn in value) went completely unflagged.
5. Unflagged fraud is split almost evenly between Cash_Out (472) and Transfer (459), so this isn't a single-channel blind spot — both need attention.
6. Fraud clusters in the highest value band: (from the Behavior & Transaction Pattern page, filtered to Amount_band = "High") Cash_Out and Transfer transactions carried fraud rates of 0.70% and 0.64% respectively within that band, well above the overall 0.13% baseline.
7. Repeat-account risk exists: The SQL model specifically isolates origin accounts with more than one fraudulent transaction, and the highest-value fraud cases (several at 10,000,000 each) show large, deliberate transfers rather than small incremental ones . It's  worth a closer manual review of the flagged account list.

<img width="884" height="472" alt="Fraud_insights" src="https://github.com/user-attachments/assets/65642b97-621a-40a9-be6b-895dda24f8b7" />

<img width="899" height="507" alt="key_findings" src="https://github.com/user-attachments/assets/984e85e3-3534-4f6e-a070-f123e7bf3da5" />

## Recommendation 
1. Rebuild the fraud-flagging logic. A 0.11% detection rate against a 100%-in-two-channels fraud pattern means the current system is not meaningfully working hence  it should be redesigned around transaction type and value, not treated as reliable in its current form.
2. Apply extra scrutiny to Transfer and Cash_Out transactions, particularly those in the "High" amount band, where observed fraud rates are 5x the overall average.
3. Introduce value-based real-time alerts/holds on very-high-value Cash_Out and Transfer transactions pending secondary verification (step-up authentication, manual review, or delayed settlement).
4. Investigate repeat-offender accounts identified by the origin-account query — these are the clearest signal of targeted or serial fraud rather than one-off incidents.
5. Monitor fraud activity by time (step/Hour_of_day) to check for time-of-day patterns that could sharpen when extra scrutiny is applied.
6. Track detection rate as an ongoing KPI, not just fraud rate — the dashboard should make it easy to see whether flagging improvements actually move the needle over time.

## Conclusion 
Fraud in this dataset is small in volume but concentrated and expensive — it lives almost entirely in Transfer and Cash_Out transactions at very high transaction values, and the existing automated flagging mechanism is missing nearly all of it. The dashboard reframes the problem from "how much fraud is there" to "where exactly should monitoring effort go" — giving management a concrete, data-backed basis for redesigning fraud controls around transaction type, value threshold, and repeat-account behavior rather than relying on a detection system that, on this evidence, isn't catching fraud today

## Presentation 
This project report is presented in a power point. The presentation contain

▪️ Business Overview 

▪️ Business Challenge 

▪️ Business Questions 

▪️ Key Insights 

▪️ Recommendation.

## Project files
project files can be seen under the repository file segment. The files contain: 
▪️ Power point presentation 

▪️ PostgreSQL script 

▪️ 3 pages PDF dashboard.

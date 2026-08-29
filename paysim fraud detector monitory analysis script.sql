drop table if exists transactions;
create table transactions(
	Step integer,
	Transaction_Type varchar (50),
	Amount numeric (18,2),
	Name_orig varchar (50),
	old_balance_orig numeric (18,2),
	New_balance_orig numeric (18,2),
	Name_destination varchar (50),
	Old_balance_destination numeric (18,2),
	New_balance_destination numeric (18,2),
	Is_fraud int,
	Is_flagged int,
	Amount_band varchar (20),
	Fraud_status varchar (20),
	Fraud_flagged_status varchar (20),
	Origin_balance_change numeric (18,2),
	Destination_balance_change numeric(18,2),
	Hour_of_day int);

select * from transactions;

select count (*) as total_rows
from transactions;

---Executive analysis
--- What is the total number of transactions, total transaction value, and average transaction value?
select
	count(*) as "total number of transaction",
	sum(Amount) as "Total transaction value",
	avg(Amount) as "Average transaction value"
from transactions;

--- Which transaction type dominates the transaction volume?
select 
	transaction_type as "transaction type",
	count (*) as "transaction count",
	round
		(count (*) * 100/sum(count(*))over(),2) as "percertage of transaction"
from transactions
group by transaction_type
order by "transaction count" desc;

---Which transaction type generates the highest value?
select 
	transaction_type as "transaction type",
	count(*) as "transaction count",
	round
		(sum(Amount),2) as "Total transaction value",
	round
		(avg(Amount),2) as "Average transaction value"
from transactions
group by transaction_type
order by "Total transaction value" desc;

---Fraud Analysis
--- How many fraudulent transaction occurred and what is the overall fraud rate?
select
	count(*) filter(where is_fraud = 1) as "Fradulent transaction",
	count(*) as "Total transaction",
	round
		(count(*) filter(where is_fraud = 1) * 100.0/count(*),2) as "fraud rate"
from transactions;

--- What is the total monetary value associated with fraudulent transactions?
select
	count(is_fraud) filter(where is_fraud = 1) as "fraudulent transaction",
	round(
		sum(Amount) filter(where is_fraud = 1),2) as "total monetary value"
from transactions;

--- Which transaction type has the highest fraud exposure?
select
	transaction_type,
	count(is_fraud) filter(where is_fraud = 1) as "fraudlent transaction",
	round
		(count(*) filter(where is_fraud = 1) * 100.0/count(*),2) as "fraud rate"
from transactions
group by transaction_type
order by "fraud rate" desc;

--- Are fraudulent transaction generally higher in value than non-fraudulent transactions?
select
	distinct(fraud_status),
	count (*) as "transaction count",
	round(
		sum(amount), 2) as "transaction value",
	round(
		Min(amount), 2) as " Minimum transaction value",
	round(
		max(amount), 2) as "Maximum transaction value"
from transactions
group by fraud_status
order by "transaction value" desc;
	
--- Monitoring analysis
--- How effective is the existing fraud_flagging mechanism?
select
	count(*) filter(where is_fraud = 1) as "Total Fraud",
	count(*) filter(where is_fraud = 1 and is_flagged = 1) as "fraud flagged correctly",
	count(*) filter(where is_fraud = 1 and is_flagged = 0) as "fraud not flagged",
	round(
		count(*) filter(where is_fraud = 1 and is_flagged = 1) * 100.0/
		count(*) filter(where is_fraud = 1),2) as "fraud detection rate"
from transactions;

--- How much fraudulent activity goes unflagged
select
	count(*) filter(where is_fraud = 1 and is_flagged = 0) as "unflagged fraud",
	round(
		sum(amount) filter(where is_fraud = 1 and is_flagged = 0),2) as  "unflagged fraud value"
from transactions;

--- Where should management focus its monitoring effort?
select 
	Transaction_type as "Transaction type",
	count(is_fraud) filter(where is_fraud = 1) as "actual fraud",
	count(*) filter(where is_fraud = 1 and is_flagged = 1) as "fraud flagged",
	count(*) filter(where is_fraud = 1 and is_flagged = 0) as "fraud not flagged"
from Transactions
group by "Transaction type"
order by "fraud not flagged" desc;

--- Which account is associated with repeated fraudulent activity?
select
	name_orig as "origin account",
	count(*) filter(where is_fraud = 1) as "fraudulent transaction",
	round(
		sum(amount) filter(where is_fraud = 1),2) as "fraudulent transaction value"
from transactions
where is_fraud = 1
group by name_orig
having count(*) filter(where is_fraud = 1)>1
order by "fraudulent transaction";

--- What transaction patterns is associated  with fraud?
select
	distinct(amount_band),
	count(*) as "total transaction",
	count(*) filter(where is_fraud = 1) as "fraudulent transaction",
	round(
		sum(amount) filter(where is_fraud = 1),2) as "fraudulent transaction value"
from transactions
group by amount_band
order by "fraudulent transaction value" desc;
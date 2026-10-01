# Supply Chain Analytics & Procurement Performance Dashboard

## Project Overview

An end-to-end supply chain analytics solution built for a logistics-sector client to consolidate scattered operational data into a unified, decision-ready dashboard. The objective is to transform raw procurement and logistics records into actionable business insights covering spend performance, supplier pricing control, and delivery reliability.

---

## Dataset

The project uses enterprise supply chain data covering multiple operational tables, including purchase orders, supplier master records, shipment logs, carrier metrics, warehouse data, and monthly budget targets.

---

## Business Problem

Management previously faced challenges tracking actual procurement spend against monthly targets due to scattered operational records. Additionally, evaluating supplier risk, delivery delays, quality rejections, and freight cost pressures required uncoordinated checks across multiple silos[cite: 5].

---

## Business Objectives

* **Spend Visibility:** Track actual procurement spend and compare it against monthly budget targets by product category.
* **Supplier Pricing Control:** Monitor purchase price variance (PPV) to identify unfavorable price movements against contracted rates.
* **Delivery Reliability:** Measure on-time delivery (OTD) and isolate delayed shipments across suppliers, carriers, regions, and transport modes.
* **Quality Leakage:** Monitor rejected quantities and supplier quality scores to mitigate risks early.
* **Logistics Cost Pressure:** Analyze freight cost distribution across different carriers and transportation modes.
* **Executive Clarity:** Provide a structured 3-page reporting layout for leadership and operational review.

---

## Key Metrics

* **Actual Spend:** Actual Unit Price multiplied by Ordered Quantity.
* **Order Volume:** Total distinct purchase order counts (`Total POs`).
* **On-Time Delivery (OTD %):** Delivered shipments completed on or before the promised date divided by total delivered shipments[cite: 5].
* **Average Lead Time:** Duration from order date to actual delivery date.
* **Rejection Rate %:** Rejected quantity divided by received quantity.
* **Purchase Price Variance (PPV %):** Actual spend minus contract spend divided by contract spend.
* **Freight Cost:** Total transportation expenses incurred for moving goods (`Sum Freight_Cost_INR`).
* **SLA Gap:** Actual OTD percentage minus the carrier SLA target[cite: 5].

---

## Business Questions & Executive Summary

### Questions Addressed
* How does actual procurement spend track against monthly targets across categories?
* Which suppliers exhibit the highest pricing variance and quality leakage?
* What are the main drivers of transportation delays and logistics cost pressures?

<div align="center"><h3>Executive Summary</h3></div>

* **Spend & Budget Tracking:** Total actual spend reached 991.94M against a total budget target of 1.02B[cite: 7]. August recorded both the highest monthly target and budget variance[cite: 7]. **Safety Supplies** emerged as the category with the highest spend-target gap at 11.3M[cite: 6].
* **Supplier Risk & Pricing:** Orders are predominantly classified under Medium supplier risk (74.04%), while CoreLink Supply Co recorded the highest purchase price variance among suppliers[cite: 7]. **Vector Component** exhibits the highest volume of rejected units among all carriers due to maximum rejections[cite: 7].
* **Logistics & Carrier Performance:** Transportation delay is inversely proportional to freight cost; Air freight commands the highest cost share (51.54%) with minimal delay cases[cite: 8]. **Delhivery B2B** stands out as a cost-effective, high-speed logistics partner due to its low freight costs and rapid delivery windows[cite: 8]. Conversely, **GATI Industrial** recorded the highest SLA gap[cite: 8], and September recorded the lowest overall OTD performance[cite: 8].

---

## Key Insights

### 1. Spend Variance & Budget Alignment
<p align="center">
  <img width="48%" alt="Actual vs Target Spend" src="https://github.com/user-attachments/assets/actual-vs-target-spend.png" />
  &nbsp;&nbsp;
  <img width="48%" alt="Spend Variance by Category" src="https://github.com/user-attachments/assets/spend-variance-category.png" />
</p>

* **Budget Utilization:** Total actual spend stands at 991.9M out of a 1.02B total budget[cite: 7].
* **Peak Variance Period:** August recorded the highest monthly target allocation and budget variance[cite: 7].
* **Category Gap:** Safety Supplies leads all product categories with a massive 11.3M spend target gap[cite: 6], followed by Office & IT Supplies (6.32M) and Electrical & Electronics (3.86M)[cite: 6].

### 2. Delay Root Cause Analysis
<p align="center">
  <img width="500" alt="Delay Breakdown" src="https://github.com/user-attachments/assets/delay-breakdown.png" />
</p>

* **Transport Mode Distribution:** Road transport accounts for the majority of delayed shipments (248 cases), followed by Rail (104 cases) and Air (69 cases)[cite: 6].
* **Carrier and Regional Bottlenecks:** GATI Industrial leads delayed road shipments (61 cases), heavily concentrated in the East (16 cases) and West (15 cases) regions[cite: 6].

### 3. Supplier Pricing & Quality Risk
<p align="center">
  <img width="48%" alt="Monthly PPV" src="https://github.com/user-attachments/assets/monthly-ppv.png" />
  &nbsp;&nbsp;
  <img width="48%" alt="PPV by Supplier" src="https://github.com/user-attachments/assets/ppv-supplier.png" />
</p>

* **Price Volatility:** September recorded the largest shift in contracted purchase prices[cite: 7].
* **Top Variance Contributors:** Suppliers like CoreLink Supply Co (0.69M PPV), Vertex TradeWorks (0.72M), and Everline Components (0.77M) drive significant pricing variance[cite: 7].
* **Quality Leakage:** Vector Component records the peak quantity of product rejections across the supplier network[cite: 7].

### 4. Logistics Cost & Carrier Efficiency
<p align="center">
  <img width="48%" alt="Freight Cost Distribution" src="https://github.com/user-attachments/assets/freight-distribution.png" />
  &nbsp;&nbsp;
  <img width="48%" alt="Carrier OTD vs SLA" src="https://github.com/user-attachments/assets/carrier-otd.png" />
</p>

* **Freight Cost Breakdown:** Air transport comprises 51.54% (12.44M) of total freight costs, compared to Road at 37.39% (9.02M) and Rail at 11.08% (2.67M)[cite: 8].
* **Carrier Benchmarks:** Delhivery B2B achieves strong delivery reliability (91.0% OTD against a 72.34% SLA baseline) with rapid transit days, outperforming carriers like GATI Industrial, which suffers from the highest SLA gap[cite: 8].

---

## Strategic Recommendations

* **Category Budget Controls:** Implement stricter purchase authorization workflows for **Safety Supplies** to curb the 11.3M spend-target gap[cite: 6].
* **Supplier Quality Audits:** Conduct targeted quality reviews with **Vector Component** to address root causes behind high product rejections[cite: 7].
* **Logistics Partner Optimization:** Shift eligible high-priority freight toward cost-effective, high-speed partners like **Delhivery B2B** while renegotiating terms with carriers showing negative SLA gaps[cite: 8].

---

## Data Model & Architecture

```text
                 DimCategory
                     │
                     │
DimDate ──────── FactProcurement (PO-Line Grain)
                     │
                 FactTargets (Category-Month Grain)

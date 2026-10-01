# Supply Chain Analytics & Procurement Performance Dashboard

## Project Overview

An end-to-end supply chain analytics solution built for a logistics-sector client to consolidate scattered operational data into a unified, decision-ready dashboard. The objective is to transform raw procurement and logistics records into actionable business insights covering spend performance, supplier pricing control, and delivery reliability.

---

## Dataset

The project uses enterprise supply chain data covering multiple operational tables, including purchase orders, supplier master records, shipment logs, carrier metrics, warehouse data, and monthly budget targets.

---

## Business Problem

Management previously faced challenges tracking actual procurement spend against monthly targets due to scattered operational records. Additionally, evaluating supplier risk, delivery delays, quality rejections, and freight cost pressures required uncoordinated checks across multiple silos.

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
* **On-Time Delivery (OTD %):** Delivered shipments completed on or before the promised date divided by total delivered shipments.
* **Average Lead Time:** Duration from order date to actual delivery date.
* **Rejection Rate %:** Rejected quantity divided by received quantity.
* **Purchase Price Variance (PPV %):** Actual spend minus contract spend divided by contract spend.
* **Freight Cost:** Total transportation expenses incurred for moving goods (`Sum Freight_Cost_INR`).
* **SLA Gap:** Actual OTD percentage minus the carrier SLA target.

---

## Business Questions & Executive Summary

### Questions Addressed
* How does actual procurement spend track against monthly targets across categories?
* Which suppliers exhibit the highest pricing variance and quality leakage?
* What are the main drivers of transportation delays and logistics cost pressures?

<div align="center"><h3>Executive Summary</h3></div>

* **Spend & Budget Tracking:** Total actual spend reached 991.94M against a total budget target of 1.02B. August recorded both the highest monthly target and budget variance. **Safety Supplies** emerged as the category with the highest spend-target gap at 11.3M.
* **Supplier Risk & Pricing:** Orders are predominantly classified under Medium supplier risk (74.04%), while CoreLink Supply Co recorded the highest purchase price variance among suppliers. **Vector Component** exhibits the highest volume of rejected units among all carriers due to maximum rejections.
* **Logistics & Carrier Performance:** Transportation delay is inversely proportional to freight cost; Air freight commands the highest cost share (51.54%) with minimal delay cases. **Delhivery B2B** stands out as a cost-effective, high-speed logistics partner due to its low freight costs and rapid delivery windows. Conversely, **GATI Industrial** recorded the highest SLA gap, and September recorded the lowest overall OTD performance.

---

## Key Insights

### 1. Spend Variance & Budget Alignment
<p align="center">
  <img width="48%" alt="Actual Vs Target Spend" src="https://github.com/user-attachments/assets/35ecd9cd-616e-4882-8828-f030e4e4657b" />
  <img width="48%" alt="Spend Variance By Category" src="https://github.com/user-attachments/assets/15167ca2-c86f-4678-b882-660a02a058a7" />
</p>

* **Budget Utilization:** Total actual spend stands at 991.9M out of a 1.02B total budget.
* **Peak Variance Period:** August recorded the highest monthly target allocation and budget variance.
* **Category Gap:** Safety Supplies leads all product categories with a massive 11.3M spend target gap, followed by Office & IT Supplies (6.32M) and Electrical & Electronics (3.86M).

### 2. Delay Root Cause Analysis
<p align="center">
  <img width="500" alt="Delay breakdown" src="https://github.com/user-attachments/assets/87aa4299-0884-4410-a3ef-0e536a14b7fc" />

</p>

* **Transport Mode Distribution:** Road transport accounts for the majority of delayed shipments (248 cases), followed by Rail (104 cases) and Air (69 cases).
* **Carrier and Regional Bottlenecks:** GATI Industrial leads delayed road shipments (61 cases), heavily concentrated in the East (16 cases) and West (15 cases) regions.

### 3. Supplier Pricing & Quality Risk
<p align="center">
  <img width="48%"  alt="Monthly PPV" src="https://github.com/user-attachments/assets/f7375edb-339c-4582-ace6-569538aafd55" />
</p>
  &nbsp;&nbsp;
  <p align="center">
  <img width="48%" alt="PPV By Supplier" src="https://github.com/user-attachments/assets/2ab7bff4-fc36-4111-9768-e3d008ad60ee" />

</p>

* **Price Volatility:** September recorded the largest shift in contracted purchase prices.
* **Top Variance Contributors:** Suppliers like CoreLink Supply Co (0.69M PPV), Vertex TradeWorks (0.72M), and Everline Components (0.77M) drive significant pricing variance.
* **Quality Leakage:** Vector Component records the peak quantity of product rejections across the supplier network.

### 4. Logistics Cost & Carrier Efficiency
<p align="center">
  <img width="48%" alt="Frieght Cost Distribution" src="https://github.com/user-attachments/assets/738683d8-5e0a-4df3-9ebd-79d99088ad84" />
</p>
* **Freight Cost Breakdown:** Air transport comprises 51.54% (12.44M) of total freight costs, compared to Road at 37.39% (9.02M) and Rail at 11.08% (2.67M).
  &nbsp;&nbsp;
  <p align="center">
  <img width="48%" alt="Carrier OTD vs SLA" src="https://github.com/user-attachments/assets/24d0f296-6ce9-496d-b7f1-90c7898557e9" />

</p>

* **Carrier Benchmarks:** Delhivery B2B achieves strong delivery reliability (91.0% OTD against a 72.34% SLA baseline) with rapid transit days, outperforming carriers like GATI Industrial, which suffers from the highest SLA gap.

---

## Strategic Recommendations

* **Category Budget Controls:** Implement stricter purchase authorization workflows for **Safety Supplies** to curb the 11.3M spend-target gap.
* **Supplier Quality Audits:** Conduct targeted quality reviews with **Vector Component** to address root causes behind high product rejections.
* **Logistics Partner Optimization:** Shift eligible high-priority freight toward cost-effective, high-speed partners like **Delhivery B2B** while renegotiating terms with carriers showing negative SLA gaps.

---

## Data Model & Architecture

```text
                 DimCategory
                     │
                     │
DimDate ──────── FactProcurement (PO-Line Grain)
                     │
                 FactTargets (Category-Month Grain)
```
* **Galaxy Schema Design:** The model utilizes two fact tables—actual procurement at the purchase-order-line grain and budget targets at the category-month grain—connected via conformed Date and Category dimensions.

---

## Tools & Technologies & Architecture

The following tools, platforms, AI capabilities, and data engineering components were utilized to build, automate, and model this end-to-end supply chain analytics solution:

* **Microsoft Fabric:** Utilized as the primary cloud analytics platform for managing data architecture, OneLake storage, and end-to-end reporting.
* **Power BI Desktop:** Used for designing the interactive, 3-page executive report layout, visualizations, and user-driven navigation.
* **DAX (Data Analysis Expressions):** Engineered for creating custom calculated measures, including Purchase Price Variance (PPV %), On-Time Delivery (OTD %), SLA Gaps, and dynamic relationship handling .
* **Dataflows & Pipelines (ETL Automation):** Integrated Fabric Dataflows (Gen2) and Data Pipelines to automate data ingestion from source files, automate transformations, and orchestrate scheduled refreshes across operational tables.
* **AI & Copilot Support:** Applied AI-assisted calculations, data profiling, and generative text insights inside the Fabric environment to support metric validation and business commentary generation.

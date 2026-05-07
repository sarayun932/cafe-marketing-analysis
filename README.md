# 📊 Café Marketing Spend & Revenue Analysis
### Welch's ANOVA · Business Data Analytics I

> Does spending more on marketing actually bring in more revenue? Analyzed real-world café operational data to statistically test whether marketing expenditure levels drive meaningful differences in daily revenue — and translated the findings into actionable budget guidance for small business owners.

---

## 🔍 Project Overview

| | |
|---|---|
| **Type** | Individual Academic Project |
| **Course** | Business Data Analysis 1: Developing Business Models through Data Analysis |
| **Institution** | Sookmyung Women's University |
| **Period** | Sep 2025 – Dec 2025 |
| **Role** | Solo — full pipeline from data preprocessing to post-hoc analysis |

---

## 🛠 Tech & Methods

`R` `Welch's ANOVA` `Games-Howell Post-hoc` `Shapiro-Wilk Test` `Levene's Test` `Descriptive Statistics` `Boxplot Visualization` `dplyr` `ggplot2` `rstatix` `car`

---

## 📌 Problem

Small business owners routinely make marketing budget decisions based on intuition rather than evidence — largely because standardized benchmarks for "how much to spend" don't exist in practice.

**Core question:**
> *"Does the level of marketing expenditure significantly affect daily revenue in café operations — and if so, by how much?"*

---

## 📂 Data

| | |
|---|---|
| **Source** | Kaggle — Coffee Shop Revenue Prediction Dataset |
| **Size** | 2,000 days of café operational data |
| **Variables** | Customers per day, average order value, operating hours, employees, marketing spend, foot traffic, daily revenue |
| **Target** | Daily revenue (continuous) |
| **Grouping variable** | marketing_group (Low / Medium / High) |

**Group Classification:**
- Low: ≤ $100
- Medium: $101–$300
- High: > $300

---

## 🔬 Methodology

**01. Exploratory Data Analysis**
Computed descriptive statistics by group and visualized revenue distributions via boxplot:
- Clear upward trend: Low < Medium < High
- High group showed greatest variability and highest median
- Outliers in Medium and High groups indicated potential for exceptionally high-revenue days

**02. Assumption Testing**

| Test | Result | Interpretation |
|---|---|---|
| Shapiro-Wilk (Low) | p = 5.05e-09 | Normality not satisfied |
| Shapiro-Wilk (Medium) | p = 2.66e-15 | Normality not satisfied |
| Shapiro-Wilk (High) | p = 8.91e-14 | Normality not satisfied |
| Levene's Test | F = 4.80, p = 0.008 | Equal variance violated |

→ Normality violated but n ≥ 30 per group → Central Limit Theorem applies
→ Equal variance violated → Welch's ANOVA selected over standard ANOVA

**03. Welch's ANOVA**
Applied as the appropriate alternative — does not require homogeneity of variances.

**04. Post-hoc Analysis (Games-Howell)**
Conducted pairwise comparisons across all three group combinations.

---

## 📊 Key Findings

**Descriptive Statistics**

| Marketing Group | Average Revenue | Std. Deviation | Sample Size |
|---|---|---|---|
| High | $2,179 | 1,003 | 782 |
| Medium | $1,829 | 919 | 848 |
| Low | $1,567 | 900 | 370 |

**Welch's ANOVA**

| F-statistic | df (num) | df (denom) | p-value |
|---|---|---|---|
| 58.227 | 2.0 | 1017.2 | < 2.2e-16 |

→ Null hypothesis rejected — at least one group differs significantly in average revenue

**Games-Howell Post-hoc**

| Comparison | Mean Difference | 95% CI | p-value |
|---|---|---|---|
| Low vs. Medium | $262 | [129.11, 394.29] | 1.25e-05 ✅ |
| Low vs. High | $613 | [473.86, 751.13] | < 0.001 ✅ |
| Medium vs. High | $351 | [239.32, 463.08] | 3.64e-14 ✅ |

All pairwise comparisons statistically significant.

---

## 🚀 Business Implications

- Marketing expenditure should not be treated as a binary decision (invest vs. not invest) but as a **scalable strategic lever** — each incremental increase yields measurable revenue gains
- Even the step from Low to Medium ($262 average gain) is statistically significant — **small budget increases matter**
- The entire revenue distribution shifts upward with higher spend — marketing investment reduces low-revenue days as well as raising the ceiling

---

## ⚠️ Limitations

- Qualitative marketing factors (content type, channel, targeting strategy) were not captured
- Analysis focused on a single independent variable — other operational drivers not controlled for
- ROI and cost-effectiveness were not evaluated
- Future research should apply multivariate techniques (e.g. multiple regression, ANCOVA)

---

## 📁 Repository Structure


├── README.md
└── cafe_marketing_analysis.R     # Full analysis pipeline


---

## 🔗 Links

- 📎 [Portfolio (Notion)](https://www.notion.so/Portfolio-356dc77303348003b532f2ed4fb72183)

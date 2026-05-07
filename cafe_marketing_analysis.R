# ============================================================
# Café Marketing Spend & Revenue Analysis
# Welch's ANOVA · Business Data Analytics I
# Institution: Sookmyung Women's University
# Author: Rayun Sa
# ============================================================


# ============================================================
# Hypothesis
# H₀: No difference in average daily revenue across
#     marketing spend groups (Low / Medium / High)
# H₁: At least one group's average daily revenue
#     is significantly different
# ============================================================


#### STEP 0: Load Data & Preprocessing ####

library(dplyr)
library(readr)

coffee <- read_csv("coffee_shop_revenue.csv")
names(coffee) <- tolower(names(coffee))
glimpse(coffee)

# Rename columns for clarity
coffee <- coffee %>% rename(
  marketing_spend = marketing_spend_per_day,
  revenue         = daily_revenue
)


#### STEP 1: Create Marketing Spend Groups ####

summary(coffee$marketing_spend)
# Min = 10.12, Max = 499.74, Median = 251.00, Mean = 252.61

coffee <- coffee %>%
  mutate(marketing_group = case_when(
    marketing_spend <= 100 ~ "Low",
    marketing_spend <= 300 ~ "Medium",
    TRUE                   ~ "High"
  ))

# Convert to ordered factor
coffee <- coffee %>%
  mutate(marketing_group = factor(marketing_group,
                                  levels = c("Low", "Medium", "High")))


#### STEP 2: Descriptive Statistics by Group ####

coffee %>%
  group_by(marketing_group) %>%
  summarise(
    mean_revenue = mean(revenue),
    sd_revenue   = sd(revenue),
    sample_size  = n()
  )

# Results:
# High:   mean = $2,179 | SD = 1,003 | n = 782
# Medium: mean = $1,829 | SD =   919 | n = 848
# Low:    mean = $1,567 | SD =   900 | n = 370


#### STEP 3: Boxplot Visualisation ####

library(ggplot2)

ggplot(coffee, aes(x = marketing_group, y = revenue, fill = marketing_group)) +
  geom_boxplot() +
  labs(
    title = "Revenue Distribution by Marketing Spend Group",
    x     = "Marketing Spend Group",
    y     = "Daily Revenue (USD)"
  ) +
  theme_minimal()


#### STEP 4: Normality Test (Shapiro-Wilk) ####

shapiro.test(coffee$revenue[coffee$marketing_group == "Low"])
shapiro.test(coffee$revenue[coffee$marketing_group == "Medium"])
shapiro.test(coffee$revenue[coffee$marketing_group == "High"])

# Results:
# Low:    p = 5.05e-09 → normality not satisfied
# Medium: p = 2.66e-15 → normality not satisfied
# High:   p = 8.91e-14 → normality not satisfied
#
# → All p-values < 0.05: normality assumption violated
# → However, n > 30 per group → Central Limit Theorem applies
# → ANOVA remains robust


#### STEP 5: Homogeneity of Variance Test (Levene's Test) ####

library(car)

leveneTest(revenue ~ marketing_group, data = coffee)

# Result: F = 4.80, p = 0.008
# → p < 0.05: equal variance assumption violated
# → Standard ANOVA not appropriate → use Welch's ANOVA


#### STEP 6: Welch's ANOVA ####

oneway.test(revenue ~ marketing_group, data = coffee, var.equal = FALSE)

# Result: F = 58.227, num df = 2.0, denom df = 1017.2, p < 2.2e-16
# → Reject H₀: at least one group differs significantly in average revenue


#### STEP 7: Post-hoc Test — Games-Howell ####

library(rstatix)

coffee %>%
  games_howell_test(revenue ~ marketing_group)

# Results:
# Low vs. Medium: diff = $262, 95% CI [129.11, 394.29], p = 1.25e-05 ✅
# Low vs. High:   diff = $613, 95% CI [473.86, 751.13], p < 0.001    ✅
# Medium vs. High: diff = $351, 95% CI [239.32, 463.08], p = 3.64e-14 ✅
#
# → All pairwise comparisons statistically significant
# → Higher marketing spend consistently associated with higher revenue

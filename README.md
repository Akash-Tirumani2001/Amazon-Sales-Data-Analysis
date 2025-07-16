# 🛒 Amazon Sales Data Analysis (SQL Project)

# Project Overview

This project aims to analyze and gain business insights from a dataset containing sales transactions from Amazon across three branches — **Mandalay**, **Yangon**, and **Naypyitaw**. The analysis is performed using **SQL** to understand patterns in sales, customer behavior, product performance, and more.

---

# Dataset Information

- **Total Rows**: 1,000 transactions
- **Columns**: 17 attributes
- **Source**: Amazon simulated sales data
- **Branches**: A (Yangon), B (Mandalay), C (Naypyitaw)

### Key Columns:
- `invoice_id`, `branch`, `city`, `customer_type`, `gender`
- `product_line`, `unit_price`, `quantity`, `VAT`, `total`
- `date`, `time`, `payment_method`, `cogs`, `gross_income`, `rating`


# Tools Used

- **SQL (MySQL)**
- **MySQL Workbench / XAMPP / phpMyAdmin**
- **Excel / CSV for raw data**


# Project Objectives

1. **Product Analysis**  
   - Identify top-performing and underperforming product lines  
2. **Sales Analysis**  
   - Understand trends across time, day, and branches  
3. **Customer Analysis**  
   - Evaluate behavior across gender and customer types  
4. **Branch-Level Insights**  
   - Determine performance by location  


# Approach

###  Data Cleaning (Data Wrangling)
- Created database and table using SQL
- Ensured `NOT NULL` constraints to avoid missing values

# Feature Engineering
- Added new columns:
  - `timeofday`: Morning / Afternoon / Evening
  - `dayname`: Day of the week
  - `monthname`: Extracted month for trend analysis

# Exploratory Data Analysis (EDA)
- Used **SQL GROUP BY**, **JOIN**, **ORDER BY**, **AVG()**, **COUNT()**, and **WINDOW FUNCTIONS**
- Answered key business questions like:
  - Which product line has the highest revenue?
  - What time of day is most profitable?
  - Which customer type spends more?
  - What city generates the highest VAT?
  - 

# Key Insights

-  **Yangon** generated the highest revenue
-  **Female customers** were slightly more frequent
-  **Afternoon** had the most transactions
-  **Health and beauty** was the top product line in terms of sales
-  **Ewallet** was the most used payment method

---

## 📁 Folder Structure
/amazon-sales-sql/
│
├── data/
│ └── amazon_sales_data.csv
├── scripts/
│ └── amazon_sales_queries.sql
├── README.md
└── insights.txt


# Contact

If you have any questions, feel free to connect!

Tirumani Akash Goud    
Gmail: naniakash71628@gmail.com 



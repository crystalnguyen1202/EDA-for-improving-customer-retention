# EDA-for-improving-customer-retention
Using SQL, PowerBI and Excel to analyze and investigate dataset of an e-commerce company.
## Situation
The Looker team created the fictional eCommerce clothes website TheLook using BigQuery Public Data on Google Cloud. This suggests that rather than being actual user data from an active website, the data is artificial or created to portray a hypothetical situation. The dataset is structured in a lengthy format and includes data on customers, items, orders, logistics, online events, and digital marketing activities. TheLook’s dataset is purposefully created to be fair and representative, free from any underlying biases or skewed distributions that may be present in data from the actual world.
Dataset: https://www.kaggle.com/datasets/mustafakeser4/looker-ecommerce-bigquery-dataset

## Task
In order to provide The Looker with useful insights from its datasets (which span the years 01-2019 to 04-2022), I carried out ad hoc jobs, created a dashboard, and carried out cohort analysis to guide TheLook’s business choices.
I used SQL (BigQuery), and PowerBI to finish this project.

## Action
### 1/ Ad-hoc tasks:
1.1 Total number of buyers and number of orders completed per month (from 01/2019 – to 04/2022)

![Screenshot 2024-08-12 014643](https://github.com/user-attachments/assets/5ec6e19c-e59f-4be3-aa95-b2b695a0239d)

1.2 Average order value (AOV) and number of customers per month

![Screenshot 2024-08-12 015105](https://github.com/user-attachments/assets/3cfe1ccc-d80b-4459-ac86-80c2340a39c1)
![Screenshot 2024-06-12 000040](https://github.com/user-attachments/assets/1e7de111-d5d4-45e7-a7e9-19c59abf255d)

1.3 Group of customers by age

![Screenshot 2024-08-12 015452](https://github.com/user-attachments/assets/d52a07e4-26fe-4129-a194-ad7ed5df0668)

Based on the results of this analysis, I found that the youngest customer was 12, the oldest customer was 70. Since then, I’ve divided customers by age into four main segments:

– Teenagers (12 – 19 years old)

– Young Adults (20 – 34 years old)

– Middle-Aged (35 – 54 years old)

– Older Adults (55 – 70 years old)

![Screenshot 2024-06-12 003855](https://github.com/user-attachments/assets/25553cc3-d135-4ac5-af43-0f027e7c94d6)

The middle-aged segment has the highest overall customer count, with 16.9K male and 17.1K female customers, making it the largest segment. The older adults and young adults segments show a clear gender imbalance, with more female customers than male customers. The teenager segment has the lowest overall customer count, with 6.8K male and 6.8K female customers, suggesting this may be a smaller or less engaged segment compared to the others. he middle-aged segment is the only one where the male and female customer counts are relatively balanced, with a difference of only around 200 customers between the genders.

1.4 Top 5 most profitable Products per Month

![Screenshot 2024-08-12 015957](https://github.com/user-attachments/assets/a78cccd7-f410-4f2c-8a8d-ed09620186dd)

1.5 Revenue at the current time for each category

Total sales statistics by date for each product category over the last 3 months (assuming the current date is 15/4/2022)

![Screenshot 2024-08-12 020130](https://github.com/user-attachments/assets/6de4069d-3499-4f8c-b3dd-75fb9132f80f)

### 2/ Create metric & build a dashboard:
It’s critical to identify the essential indicators that will offer insightful information about business performance before creating a dashboard. The aims and objectives of the company should be reflected in these indicators. These are some important parameters to take into account for inclusion:

– TPV : the total revenue of all orders per month

– TPO : the total number of orders per month

– Total_cost : the total cost of virginity in the process of operating and selling the product per month

– Total_profit : the total profit from selling goods per month

– Profit_to_cost_ratio: total_profit/total_cost per month

– Revenue_growth : the percentage increase in revenue per mont

– Order_growth : the percentage increase in number of orders per month


![Screenshot 2024-08-12 020317](https://github.com/user-attachments/assets/a1f056f6-604e-46db-9ced-2eadf3e4cff9)

![Screenshot 2024-06-12 011835](https://github.com/user-attachments/assets/32586859-e096-4300-9baf-d96b7da9b923)

This dashboard provides a comprehensive overview of the business’s financial and operational performance. Here are the key insights I can gather from the information presented:

– Financial performance: The total profit for the business is $95.84M, while the total cost is $88.83M, indicating a healthy profit margin. The profit-to-cost ratio has fluctuated over the years, but shows an overall upward trend, suggesting improved efficiency.

– Customer segmentation: The customer base is primarily divided into four segments: middle-aged, older adults, young adults, and teenagers. The middle-aged and older adult segments make up the largest portion of the customer base, accounting for over 60% of the total customers.

– Revenue and Order growth: Both revenue growth and order growth have experienced significant fluctuations, with a sharp increase in 2020 followed by a decline and subsequent recovery. The revenue growth and order growth trends are closely aligned, indicating a strong correlation between these two metrics.

– Top Product categories: The top-performing product categories in terms of Total Product Value (TPV) are Outerwear & Accessories, Jeans, Sweaters, Suits & Sport, and Swim. These categories appear to be the key revenue drivers for the business.

– Product Category profitability: The “Intimates” category has the highest TPV, suggesting it is the most profitable product category for the business. Other high-performing categories in terms of TPV include Jeans, Tops & Tees, and Fashion Hoods.

## 3/ Retention cohort analysis
A cohort analysis will be developed in order to evaluate client retention. With the use of this research, we will be able to monitor the actions of particular consumer cohorts over time and determine whether or not they are making additional purchases following their original transaction.













import pandas as pd
from sqlalchemy import create_engine

# -------------------------
# Load Excel Data
# -------------------------
print("\nLoading Excel dataset...")

excel_file = r"C:\Users\BADAL\Downloads\POWER_BI PROJECT DATA\Mobile Sales Data.xlsx"
df = pd.read_excel(excel_file)

print("Dataset Loaded Successfully!")
print("Shape:", df.shape)
print(df.head())


# -------------------------
# Cleaning
# -------------------------
print("\nCleaning Data...")

df.drop_duplicates(inplace=True)

df["DATE"] = pd.to_datetime(
    df["Day"].astype(str) + "-" + df["Month"].astype(str) + "-" + df["Year"].astype(str),
    format="%d-%m-%Y",
    errors="coerce"
)

df["Customer Ratings"] = df["Customer Ratings"].fillna(df["Customer Ratings"].mean())
df["Customer Age"] = df["Customer Age"].fillna(df["Customer Age"].median())
df["Payment Method"] = df["Payment Method"].fillna("Unknown")

print("Cleaning Done!")
print("Shape:", df.shape)


# -------------------------
# Feature Engineering
# -------------------------
print("\nCreating new columns...")

df["Total_Sale"] = df["Units Sold"] * df["Price Per Unit"]
df["Day Name"] = df["DATE"].dt.day_name()

def rating_status(r):
    if r >= 4:
        return "Good"
    elif r >= 3:
        return "Average"
    else:
        return "Bad"

df["Rating_Status"] = df["Customer Ratings"].apply(rating_status)

print("New columns created successfully!")


# -------------------------
# MySQL Connection using SQLAlchemy
# -------------------------
print("\nConnecting to MySQL using SQLAlchemy...")

USER = "root"
PASSWORD = "214112Badal"     # change this
HOST = "localhost"
DB = "mobile_sales_db"

engine = create_engine(f"mysql+pymysql://{USER}:{PASSWORD}@{HOST}/{DB}")

print("Connected Successfully!")


# -------------------------
# Load Data into MySQL
# -------------------------
print("\nStoring data into MySQL table...")

df.to_sql("sales_data", con=engine, if_exists="replace", index=False)

print("Data stored successfully in MySQL!")


# -------------------------
# Analytics Queries
# -------------------------
print("\nRunning Analytics Queries...")

# Query 1: Total Sales by Brand
q1 = """
SELECT Brand, ROUND(SUM(Total_Sale),2) AS total_sales
FROM sales_data
GROUP BY Brand
ORDER BY total_sales DESC;
"""
brand_sales = pd.read_sql(q1, con=engine)
print("\nTotal Sales by Brand:")
print(brand_sales)

# Query 2: Total Quantity by City
q2 = """
SELECT City, SUM(`Units Sold`) AS total_quantity
FROM sales_data
GROUP BY City
ORDER BY total_quantity DESC;
"""
city_qty = pd.read_sql(q2, con=engine)
print("\nTotal Quantity Sold by City:")
print(city_qty)

# Query 3: Top 5 Mobile Models by Sales
q3 = """
SELECT `Mobile Model`, ROUND(SUM(Total_Sale),2) AS total_sales
FROM sales_data
GROUP BY `Mobile Model`
ORDER BY total_sales DESC
LIMIT 5;
"""
top_models = pd.read_sql(q3, con=engine)
print("\nTop 5 Mobile Models by Sales:")
print(top_models)

# Query 4: Payment Method wise Sales
q4 = """
SELECT `Payment Method`, ROUND(SUM(Total_Sale),2) AS total_sales
FROM sales_data
GROUP BY `Payment Method`
ORDER BY total_sales DESC;
"""
payment_sales = pd.read_sql(q4, con=engine)
print("\nSales by Payment Method:")
print(payment_sales)

# Query 5: Rating Status Distribution
q5 = """
SELECT Rating_Status, COUNT(*) AS total_transactions
FROM sales_data
GROUP BY Rating_Status;
"""
rating_dist = pd.read_sql(q5, con=engine)
print("\nRating Status Distribution:")
print(rating_dist)


# -------------------------
# Export Reports
# -------------------------
print("\nSaving reports as CSV...")

brand_sales.to_csv("report_brand_sales.csv", index=False)
city_qty.to_csv("report_city_quantity.csv", index=False)
top_models.to_csv("report_top_models.csv", index=False)
payment_sales.to_csv("report_payment_sales.csv", index=False)
rating_dist.to_csv("report_rating_distribution.csv", index=False)

print("Reports saved successfully!")
print("\nScript Completed Successfully")

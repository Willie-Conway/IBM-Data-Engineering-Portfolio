SELECT product, segment, sum(sales) as TotalSales  From Sales
Group by segment, product
Having sum(sales)>100000
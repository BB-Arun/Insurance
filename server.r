require(DBI)
require(RMySQL)
require(data.table)

whcon <- dbConnect(RMySQL::MySQL(),dbname='warehouse',host='10.3.2.101',
                   port=3306,user='warehouse_ro',password='u@ssh0l3')

sql <- "SELECT appsum.app_id, pt.value, appsum.applicant_gross_monthly_income,
appsum.applicant_income,
appsum.applicant_net_annual_income,
appsum.co_applicant_gross_monthly_income,
appsum.co_applicant_income,
appsum.co_applicant_net_annual_income
FROM application_summary as appsum left join product_type as pt on appsum.product_type_id = pt.id
where created_on>=curdate()-60 and product_type_id in (54,56,59,60)"

df <- as.data.table(dbGetQuery(whcon,sql))
df2 <- df[which(apply(df[,3:8],1,sum,na.rm=T)>0),]
apply(df2[,3:8]/10^5,2,sum,na.rm=T)
unique(df2[,2])

dbDisconnect(whcon)

#changes to server branch.
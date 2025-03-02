from langchain import PromptTemplate, LLMChain
from langchain.llms import GooglePalm
from langchain_google_genai import ChatGoogleGenerativeAI
import pandas as pd
import os


# Define the bank transactions
transactions = [
'''
Account No,DATE,TRANSACTION DETAILS,CHQ.NO.,VALUE DATE, WITHDRAWAL AMT , DEPOSIT AMT 
1196428',1-Jan-15,DSB CASH PICKP IndiaforensicMET0,,1-Jan-15,,"  1,200,000.00 "
1196428',1-Jan-15,BEAT CASH PICKP DELH 3925,,1-Jan-15,,"  800,000.00 "
1196428',2-Jan-15,CHQ DEP/45811/OWDEL1/BARB,,2-Jan-15,,"  15,000.00 "
1196428',2-Jan-15,CHQ DEP/237843/OWDEL1/SBI,,2-Jan-15,,"  25,000.00 "
1196428',2-Jan-15,CHQ DEP/252242/OWDEL1/SBI,,2-Jan-15,,"  25,000.00 "
1196428',2-Jan-15,CHQ DEP/252243/OWDEL1/SBI,,2-Jan-15,,"  25,000.00 "
1196428',2-Jan-15,RTGS CHARGES AND STAX/RAT,,2-Jan-15,  56.18 ,
1196428',2-Jan-15,RTGS/YESBH15002745737/Indfor,4549,2-Jan-15,"  5,500,000.00 ",
1196428',2-Jan-15,DSB CASH PICKP IndiaforensicMET0,,2-Jan-15,,"  1,500,000.00 "
1196428',2-Jan-15,DSB CASH PICKP IndiaforensicGUR0,,2-Jan-15,,"  172,620.00 "
1196428',2-Jan-15,BEAT CASH PICKP DELH 3925,,2-Jan-15,,"  700,000.00 "
1196428',3-Jan-15,FUND TRF TO  Indiaforensic SERVI,4550,3-Jan-15,"  2,200,000.00 ",
1196428',3-Jan-15,DSB CASH PICKP IndiaforensicMET0,,3-Jan-15,,"  2,200,000.00 "
1196428',3-Jan-15,DSB CASH PICKP IndiaforensicGUR0,,3-Jan-15,,"  48,160.00 "
1196428',3-Jan-15,BEAT CASH PICKP DELH 3796,,3-Jan-15,,"  700,000.00 "
1196428',5-Jan-15,FUND TRF TO  Indiaforensic SERVI,704026,5-Jan-15,"  3,230,000.00 ",
1196428',5-Jan-15,DSB MUTI CSH Indfor METRO030,,5-Jan-15,"  1,000.00 ",
1196428',5-Jan-15,BEAT CASH PICKP DELH 3796,,5-Jan-15,,"  700,000.00 "
1196428',5-Jan-15,DSB CASH PICKP IndiaforensicMET0,,5-Jan-15,,"  3,000,000.00 "
1196428',5-Jan-15,DSB CASH PICKP IndiaforensicGUR0,,5-Jan-15,,"  177,320.00 "
1196428',6-Jan-15,RTGS CHARGES AND STAX/RAT,,6-Jan-15,  56.18 ,
1196428',6-Jan-15,RTGS/YESBH15006775107/Indfor,704027,6-Jan-15,"  3,880,000.00 ",
1196428',6-Jan-15,BEAT CASH PICKP DELH 3796,,6-Jan-15,,"  800,000.00 "
1196428',6-Jan-15,DSB EXCESS Indfor MET050115,,6-Jan-15,,"  7,500.00 "
1196428',6-Jan-15,DSB CASH PICKP IndiaforensicMET0,,6-Jan-15,,"  2,500,000.00 "
1196428',6-Jan-15,DSB CASH PICKP IndiaforensicGUR0,,6-Jan-15,,"  343,250.00 "
1196428',7-Jan-15,RTGS/YESBH15007783094/Indfor,704028,7-Jan-15,"  3,650,000.00 ",
1196428',7-Jan-15,DSB CASH PICKP IndiaforensicMET0,,7-Jan-15,,"  2,200,000.00 "
1196428',7-Jan-15,DSB CASH PICKP IndiaforensicGUR0,,7-Jan-15,,"  455,070.00 "
1196428',7-Jan-15,BEAT CASH PICKP DELH 3796,,7-Jan-15,,"  800,000.00 "
1196428',8-Jan-15,RTGS/YESBH15008794037/Indfor,704029,8-Jan-15,"  3,450,000.00 ",
1196428',8-Jan-15,DSB CASH PICKP IndiaforensicMET0,,8-Jan-15,,"  3,000,000.00 "
1196428',8-Jan-15,DSB CASH PICKP IndiaforensicGUR0,,8-Jan-15,,"  850,200.00 "
1196428',8-Jan-15,BEAT CASH PICKP DELH 3796,,8-Jan-15,,"  700,000.00 "
1196428',9-Jan-15,RTGS/YESBH15009802859/Indfor,704030,9-Jan-15,"  4,550,000.00 ",
1196428',9-Jan-15,BEAT CASH PICKP DELH 3796,,9-Jan-15,,"  700,000.00 "
1196428',9-Jan-15,DSB CASH PICKP IndiaforensicMET0,,9-Jan-15,,"  3,200,000.00 "
1196428',9-Jan-15,DSB CASH PICKP IndiaforensicGUR0,,9-Jan-15,,"  1,002,100.00 "
1196428',10-Jan-15,FUND TRF  TO  Indiaforensic SERV,704031,10-Jan-15,"  3,900,000.00 ",
1196428',10-Jan-15,CHQ DEP/652949/OWDEL1/SBI,,10-Jan-15,,"  25,000.00 "
1196428',10-Jan-15,CHQ DEP/846511/OWDEL1/SBI,,10-Jan-15,,"  25,000.00 "
1196428',10-Jan-15,CHQ DEP/554750/OWDEL1/SBI,,10-Jan-15,,"  15,000.00 "
1196428',10-Jan-15,CHQ DEP/814921/OWDEL1/CNR,,10-Jan-15,,"  2,000.00 "
1196711',22-Jul-15,AIRTEL RELATIONSHIP 11520,873755,22-Jul-15,  285.00 ,,"  -1,013,667,191.32 "
1196711',22-Jul-15,AIRTEL RELATIONSHIP 11614,873758,22-Jul-15,  285.00 ,,"  -1,013,667,476.32 "
1196711',22-Jul-15,AIRTEL RELATIONSHIP 11551,873757,22-Jul-15,  285.00 ,,"  -1,013,667,761.32 "
1196711',22-Jul-15,AIRTEL RELATIONSHIP 10951,873756,22-Jul-15,  285.00 ,,"  -1,013,668,046.32 "
1196711',24-Jul-15,MAHAK HOLIDAY,873763,24-Jul-15,"  12,971.00 ",,"  -990,046,178.45 "
1196711',24-Jul-15,SACHIN GOEL,873766,24-Jul-15,"  2,000.00 ",,"  -990,048,178.45 "
'''
]

# Set up the Gemini model
os.environ["GOOGLE_API_KEY"] = "AIzaSyBeak8uc0WsLZRjh5U3s8REdfElZl52-uY"
model = ChatGoogleGenerativeAI(model="gemini-1.5-pro-latest",
                             temperature=0.3)

# Create a prompt template
template = """
Given the categories:
Housing, home services, utilities, transportation, food, health and medical, personal care, clothing, children, pets, entertainment & recreation, travel, technology, gifts and donations, insurance, savings and investments, debt payments, professional services, education, miscellaneous


User Transactions:
{transactions}

Try to categorize into as many categories(minimum 4) as you can.
Now for each transaction, print with headers "category" and "amount". Try to categorize into as many categories as you can.
Please follow the given format:
category,amount
cat1,amount1
cat2,amount2

Do not output anything apart from this
"""

prompt = PromptTemplate(
    input_variables=["transactions"],
    template=template
)

# Create the LLM chain
chain = LLMChain(llm=model, prompt=prompt)

# Prepare the input
transactions_str = "\n".join([str(t) for t in transactions])

# Run the chain
result = chain.run({
    "transactions": transactions_str
})

print(result)

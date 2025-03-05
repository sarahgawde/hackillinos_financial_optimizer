from langchain import PromptTemplate, LLMChain
from langchain.llms import GooglePalm
from langchain_google_genai import ChatGoogleGenerativeAI
import pandas as pd
import os
import re

def parse_card_recommendations(data):
    parsed_cards = {}
    matches = re.findall(r'Card Name:\s*(.*?)\s*Reason:\s*(.*?)\s*(?=Card Name:|$)', data, re.DOTALL)

    for i, match in enumerate(matches, start=1):
        card_name, reason = match
        parsed_cards[f"card_name_{i}"] = card_name.strip()
        parsed_cards[f"reason_{i}"] = reason.strip()

    return parsed_cards

def generate_card_recommendation(transactions):
    # Load the CSV file
    # credit_cards_df = pd.read_csv('creditcard_list.csv')
    # print(transactions)

    # Set up the Gemini model
    os.environ["GOOGLE_API_KEY"] = "AIzaSyBeak8uc0WsLZRjh5U3s8REdfElZl52-uY"
    model = ChatGoogleGenerativeAI(model="gemini-1.5-pro-latest",
                                temperature=0.3)

    # Create a prompt template
    template = """
    Given the following credit card information and user transactions, suggest the most suitable credit card for the user.

    Credit Card Information:
    {credit_cards}

    User Transactions:
    {transactions}

    Please provide your recommendations in the following format:
    Card Name: [Recommended Card Name]
    Reason: [Brief explanation of why this card is recommended. Do not compare it with other cards. Instead of this, use you to refer to the user]

    Card Name: [Recommended Card Name]
    Reason: [Brief explanation of why this card is recommended. Do not compare it with other cards. Instead of this, use you to refer to the user]
    """

    prompt = PromptTemplate(
        input_variables=["credit_cards", "transactions"],
        template=template
    )

    # Create the LLM chain
    chain = LLMChain(llm=model, prompt=prompt)

    # Prepare the input
    # credit_cards_str = credit_cards_df.to_string(index=False)
    credit_cards_str = """
    Alaska Airlines Visa Signature® credit card
                    About Our RatingsRead our full reviewLIMITED TIME ONLINE OFFER-70,000 Bonus Miles!Get 70,000 bonus miles plus Alaska's Famous Companion Fare™ ($99 fare plus taxes and fees from $23) with this offer. To qualify, make $3,000 or more in purchases within the first 90 days of opening your account.Get Alaska's Famous Companion Fare™ ($99 fare plus taxes and fees from $23) each account anniversary after you spend $6,000 or more on purchases within the prior anniversary year. Valid on all Alaska Airlines flights booked on alaskaair.com.Earn unlimited 3 miles for every $1 spent on eligible Alaska Airlines purchases. Earn unlimited 2 miles for every $1 spent on eligible gas, EV charging station, cable, streaming services and local transit (including ride share) purchases. And earn unlimited 1 mile per $1 spent on all other purchases. And, your miles don't expire on active accounts.Earn a 10% rewards bonus on all miles earned from card purchases if you have an eligible Bank of America® account.Free checked bag and enjoy priority boarding for you and up to 6 guests on the same reservation, when you pay for your flight with your card - Also available for authorized users when they book a reservation too!With oneworld® Alliance member airlines and Alaska's Global Partners, Alaska has expanded their global reach to over 1,000 destinations worldwide bringing more airline partners and more ways to earn and redeem miles.Plus, no foreign transaction fees and a low $95 annual fee.This online only offer may not be available elsewhere if you leave this page. You can take advantage of this offer when you apply now.See MoreAPPLY NOWon Bank of America Credit Cards's 
    secure website Credit Needed
    Excellent/Good

    "Alaska Airlines Visa® Business card
                    About Our RatingsRead our full reviewGet 70,000 bonus miles and Alaska's Famous Companion Fare™ ($99 fare plus taxes and fees from $23) after you make $4,000 or more in purchases within the first 90 days of opening your account.Earn another Alaska's Famous Companion Fare™ ($99 fare plus taxes and fees from $23) each account anniversary after spending $6,000 or more on purchases within the prior anniversary year.Free checked bag for any cardholder and up to 6 guests on the same reservation when you pay for your flight with your card - that's a savings of $70 per person roundtrip!Priority Boarding for any cardholder when paying for the flight with an Alaska Airlines Business card.Earn 3 miles for every $1 spent on eligible Alaska Airlines purchases, 2 miles for every $1 spent on eligible gas, EV charging station, shipping and local transit (including rideshare) purchases and 1 mile for every $1 spent on all other purchases.Earn a 10% rewards bonus on all miles earned from card purchases if your company has an eligible Bank of America® small business account.Enjoy 20% back on Alaska Airlines inflight purchases when you pay with your new card.Get $100 off an annual Alaska Lounge+ Membership purchased with your Alaska Airlines Business card.Plus, no international transaction fees and a low annual fee of $70 for the company and $25 per card.This offer may not be available if you leave this page or visit our website. You can take advantage of this offer when you apply now.See MoreAPPLY NOWon Bank of America Credit Cards's 
    secure websiteCredit Needed
    Excellent"

    "Amazon Business American Express Card
                    About Our RatingsRead our full reviewGet a $100 Amazon Gift Card upon approval for the Amazon Business American Express Card.Take advantage of 3% Back and benefit your bottom line or 60 day no-interest terms to free up your cash flow on U.S. purchases at Amazon Business, AWS, Amazon.com and Whole Foods Market. Earn 3% Back on the first $120,000 in purchases each calendar year, 1% Back thereafter2% Back at U.S. restaurants, U.S. gas stations, and on wireless telephone services purchased directly from U.S. service providers1% Back on other purchasesNo Annual Fee¤Back your business with the broad selection of Amazon and the service of American Express. Stay focused on your top business priorities, knowing we're behind you.You choose when to redeem. Redeem rewards on millions of items during checkout at Amazon.com and Amazon Business (U.S.) or apply towards a purchase on your statement.Terms apply.See MoreSee Rates and Fees; terms applyAPPLY NOWon American Express (Impact Radius)'s 
    secure websiteCredit Needed
    Excellent, Good"

    "Amazon Business Prime American Express Card
                    About Our RatingsRead our full reviewEligible Prime Members get a $125 Amazon Gift Card upon approval for the Amazon Business Prime American Express Card.Take advantage of 5% Back or 90 day Terms on U.S. purchases at Amazon Business, AWS, Amazon.com and Whole Foods Market with eligible Prime membership. You can earn 5% Back on the first $120,000 in purchases each calendar year, 1% Back thereafter2% Back at U.S. restaurants, U.S. gas stations, and on wireless telephone services purchased directly from U.S. service providers1% Back on other purchasesNo Annual Fee¤Back your business with the broad selection of Amazon and the service of American Express. Stay focused on your top business priorities, knowing we're behind you.Redeem rewards on millions of items during checkout at Amazon.com and Amazon Business (U.S.) or apply towards a purchase on your statement.Terms apply.See MoreSee Rates and Fees; terms applyAPPLY NOWon American Express (Impact Radius)'s 
    secure websiteCredit Needed
    Excellent, Good"

    "American Airlines AAdvantage® MileUp® Card
                    About Our RatingsRead our full reviewEarn 15,000 American Airlines AAdvantage® bonus miles after making $1,000 in purchases within the first 3 months of account opening.0% Intro APR for 15 months on balance transfers; after that, the variable APR will be 20.24% - 29.24%, based on your creditworthiness. Interest will be charged on purchases unless you pay the balance due, including balance transfers, by the due date each month. Balance transfer fee of either $5 or 5% of the amount of each credit card balance transfer, whichever is greater. Balance Transfers must be completed within 4 months of account opening. No Annual Fee Earn 2 AAdvantage® miles for each $1 spent at grocery stores, including grocery delivery services Earn 2 AAdvantage® miles for every $1 spent on eligible American Airlines purchasesSave 25% on inflight food and beverage purchases when you use your card on American Airlines flightsSee MoreSee Rates and FeesAPPLY NOWon Citi Bank Credit Cards's 
    secure websiteCredit Needed
    Excellent, Good"

    "Bank of America® Platinum Plus® Mastercard® Business card
                    About Our RatingsGet a $300 online statement credit after you make at least $3,000 in purchases in the first 90 days of your account opening.Save on interest with a competitive purchase APR.No annual fee.0% Introductory APR on purchases for the first 7 billing cycles. After the intro APR offer ends, a Variable APR that's currently 15.49% to 26.49% will apply.Get employee cards at no additional cost to you and with credit limits you set.Contactless Cards - The security of a chip card, with the convenience of a tap.This offer may not be available if you leave this page or visit our website. You can take advantage of this offer when you apply now.See MoreAPPLY NOWon Bank of America Credit Cards's 
    secure websiteCredit Needed
    Excellent"

    "Bank of America® Premium Rewards® credit card
                    About Our RatingsRead our full reviewLow $95 annual fee.Receive 60,000 online bonus points - a $600 value - after you make at least $4,000 in purchases in the first 90 days of account opening.Earn unlimited 2 points for every $1 spent on travel and dining purchases and unlimited 1.5 points for every $1 spent on all other purchases. No limit to the points you can earn and your points don't expire as long as your account remains open.If you're a Bank of America Preferred Rewards® member, you can earn 25%-75% more points on every purchase. That means you could earn 2.5-3.5 points on travel and dining purchases and 1.87 - 2.62 points on all other purchases, for every $1 you spend.Redeem for cash back as a statement credit, deposit into eligible Bank of America® accounts, credit to eligible Merrill® accounts, or gift cards or purchases at the Bank of America Travel Center.Get up to $100 in Airline Incidental Statement Credits annually and TSA PreCheck®/Global Entry Statement Credits of up to $100, every four years.Travel Insurance protections to assist with trip delays, cancellations and interruptions, baggage delays and lost luggage.No foreign transaction fees.This online only offer may not be available if you leave this page or if you visit a Bank of America financial center. You can take advantage of this offer when you apply now.See MoreAPPLY NOWon Bank of America Credit Cards's 
    secure websiteCredit Needed
    Excellent/Good"

    "Blue Cash Everyday® Card from American Express
                    About Our RatingsRead our full reviewEarn a $200 statement credit after you spend $2,000 in purchases on your new Card within the first 6 months.No Annual Fee.Enjoy 0% intro APR on purchases and balance transfers for 15 months from the date of account opening. After that, 18.24% to 29.24% variable APR.3% Cash Back at U.S. supermarkets on up to $6,000 per year in purchases, then 1%.3% Cash Back on U.S. online retail purchases, on up to $6,000 per year, then 1%.3% Cash Back at U.S. gas stations, on up to $6,000 per year, then 1%.Cash back is received in the form of Reward Dollars that can be redeemed as a statement credit or at Amazon.com checkout.Thinking about getting the Disney Bundle which can include Disney+, Hulu, and ESPN+? Your decision made easy with $7/month back in the form of a statement credit after you spend $9.99 or more each month on an eligible subscription (subject to auto renewal) with your Blue Cash Everyday® Card. Enrollment required.Enjoy up to $15 back per month when you purchase a Home Chef meal kit subscription (subject to auto renewal) with your enrolled Blue Cash Everyday® Card.Apply with confidence. Know if you're approved for a Card with no impact to your credit score. If you're approved and you choose to accept this Card, your credit score may be impacted.Terms Apply.See MoreSee Rates and Fees; terms applyAPPLY NOWon American Express (Impact Radius)'s 
    secure websiteCredit Needed
    Good, Excellent"

    "Business Green Rewards Card from American Express
                    About Our RatingsRead our full reviewEarn 15,000 Membership Rewards® points after you spend $3,000 in eligible purchases on the Business Green Rewards Card within the first 3 months of Card MembershipEarn one Membership Rewards® point for each dollar you spend on eligible purchasesPAY OVER TIME OPTION: Decide whether you want to pay eligible purchases in full each month-or pay over time with interest, up to the Pay Over Time Limit on your accountFrom travel to top brands, and everything in between - use Membership Rewards® points on the reward that means the most to you$95 Annual FeeTerms & Limitations ApplySee MoreSee Rates and Fees; terms applyAPPLY NOWon American Express (Impact Radius)'s 
    secure websiteCredit Needed
    Good, Excellent"

    "Delta SkyMiles® Blue American Express CardAbout Our RatingsRead our full reviewEarn 10,000 bonus miles after you spend $1,000 in purchases on your new Card in your first 6 months.No Annual Fee.Earn 2X Miles per dollar at restaurants worldwide, plus takeout and delivery in the U.S.Earn 10,000 bonus miles after you spend $1,000 in purchases on your new Card in your first 6 months.No Annual Fee.Earn 2X Miles per dollar at restaurants worldwide, plus takeout and delivery in the U.S.Earn 2X Miles per dollar spent on Delta purchases, and 1X Mile on all other eligible purchases.Pay with Miles: take up to $50 off the cost of your flight for every 5,000 miles you redeem with Pay with Miles when you book on delta.com.Receive a 20% savings in the form of a statement credit after you use your Card on eligible Delta in-flight purchases of food and beverages.No Foreign Transaction Fees.Apply with confidence. Know if you're approved for a Card with no impact to your credit score. If you're approved and you choose to accept this Card, your credit score may be impacted.Terms Apply.See MoreSee Rates and Fees; terms applyAPPLY NOWon American Express (Impact Radius)'s 
    secure websiteCredit Needed
    Good, Excellent"

    "Delta SkyMiles® Gold Business American Express CardAbout Our RatingsRead our full reviewLimited Time Offer: Earn 90,000 Bonus Miles after spending $6,000 in purchases on your new Card in your first 6 months of Card Membership. Offer Ends 4/2/25.$0 introductory annual fee for the first year, then $150Card Members save 15% when booking Award Travel with miles on Delta flights when using delta.com and the Fly Delta app. Discount not applicable to partner-operated flights or to taxes and fees.Limited Time Offer: Earn 90,000 Bonus Miles after spending $6,000 in purchases on your new Card in your first 6 months of Card Membership. Offer Ends 4/2/25.$0 introductory annual fee for the first year, then $150Card Members save 15% when booking Award Travel with miles on Delta flights when using delta.com and the Fly Delta app. Discount not applicable to partner-operated flights or to taxes and fees.Additionally, you can receive a $200 Delta Flight Credit to use toward future travel after you spend $10,000 in purchases in a year.Earn 2 miles per dollar spent on purchases at U.S. Shipping providers and at U.S. providers for Advertising in select media on up to $50,000 of purchases per category, per year.Earn 2 Miles on every dollar spent on eligible purchases made directly with Delta and on every eligible dollar spent at restaurants.Earn 1 Mile on every eligible dollar spent on other purchases.Check and stow your bag with ease: First Checked Bag Free on Delta Flights + Zone 5 Priority Boarding on Delta flights.Elevate your travel experience with an annual statement credit of up to $150 after using your Delta SkyMiles® Gold Business American Express Card to book prepaid hotels or vacation rentals through Delta Stays on delta.com.Receive a 20% savings in the form of a statement credit on eligible Delta in-flight purchases after using your Card.Pay no foreign transaction fees when you travel overseas.Terms and limitations apply.See MoreSee Rates and Fees; terms applyAPPLY NOWon American Express (Impact Radius)'s 
    secure websiteCredit Needed
    Excellent, Good"

    "Discover it® Secured Credit CardAbout Our RatingsRead our full reviewNo credit score required to apply. No Annual Fee.Your secured credit card requires a refundable security deposit, and your credit line will equal your deposit amount, starting at $200. Bank information must be provided when submitting your deposit.Raise your credit score by 30+ points.No credit score required to apply. No Annual Fee.Your secured credit card requires a refundable security deposit, and your credit line will equal your deposit amount, starting at $200. Bank information must be provided when submitting your deposit.Raise your credit score by 30+ points.Automatic reviews starting at 7 months to see if we can transition you to an unsecured line of credit and return your deposit.Earn 2% cash back at Gas Stations and Restaurants on up to $1,000 in combined purchases each quarter, automatically. Plus earn unlimited 1% cash back on all other purchases.Discover could help you reduce exposure of your personal information online by helping you remove it from select people-search sites that could sell your data. Activate by mobile app for free.Get an alert if we find your Social Security number on any of thousands of Dark Web sites. Activate for free.Terms and conditions apply.See MoreSee Rates and FeesAPPLY NOWon Discover (Impact Radius)'s 
    secure websiteCredit Needed
    New, Rebuilding"

    "Disney® Premier Visa® CardAbout Our RatingsRead our full reviewEarn a $300 Statement Credit after you spend $1,000 on purchases in the first 3 months from account opening.Earn 5% in Disney Rewards Dollars on card purchases made directly at DisneyPlus.com, Hulu.com or ESPNPlus.com. Earn 2% in Disney Rewards Dollars on card purchases at gas stations, grocery stores, restaurants and most Disney U.S. locations. Earn 1% on all your other card purchases. There are no limits to the number of Rewards Dollars you can earn.Redeem Rewards Dollars for a statement credit toward airline purchases.Earn a $300 Statement Credit after you spend $1,000 on purchases in the first 3 months from account opening.Earn 5% in Disney Rewards Dollars on card purchases made directly at DisneyPlus.com, Hulu.com or ESPNPlus.com. Earn 2% in Disney Rewards Dollars on card purchases at gas stations, grocery stores, restaurants and most Disney U.S. locations. Earn 1% on all your other card purchases. There are no limits to the number of Rewards Dollars you can earn.Redeem Rewards Dollars for a statement credit toward airline purchases.0% promo APR for 6 months on select Disney vacation packages from the date of purchase, after that a variable APR of 18.24% to 27.24%10% off select merchandise purchases at select locations and 10% off select dining locations most days at the Disneyland® Resort and Walt Disney World® Resort.Save 10% on select purchases at DisneyStore.comMember FDICSee MoreAPPLY NOWon Chase Credit Cards's 
    secure websiteCredit Needed
    Excellent/Good"

    "Southwest Rapid Rewards® Priority Credit CardAbout Our RatingsRead our full reviewLimited-time offer: earn Companion Pass® good through 2/28/26 plus 30,000 points after you spend $4,000 on purchases in the first 3 months from account opening.7,500 anniversary points each year.Earn 3X points on Southwest® purchases.Limited-time offer: earn Companion Pass® good through 2/28/26 plus 30,000 points after you spend $4,000 on purchases in the first 3 months from account opening.7,500 anniversary points each year.Earn 3X points on Southwest® purchases.Earn 2X points on local transit and commuting, including rideshare.Earn 2X points on internet, cable, and phone services; select streaming.$75 Southwest® travel credit each year.No foreign transaction fees.Member FDICSee MoreAPPLY NOWon Chase Credit Cards's 
    secure websiteCredit Needed
    Excellent, Good"

    "Surge® Platinum Mastercard®About Our RatingsUp to $1,000 Initial Credit LimitSee if you Pre-Qualify with No Impact to your Credit ScoreLess than perfect credit? We understand. The Surge Mastercard is ideal for people looking to rebuild their credit.Up to $1,000 Initial Credit LimitSee if you Pre-Qualify with No Impact to your Credit ScoreLess than perfect credit? We understand. The Surge Mastercard is ideal for people looking to rebuild their credit.Unsecured credit card requires No Security DepositPerfect card for everyday purchases and unexpected expensesMonthly reporting to the three major credit bureausAccess to your Vantage 3.0 Score from Experian (when you sign up for e-statements)Use your card everywhere Mastercard is accepted at millions of locationsEnjoy peace of mind with Mastercard Zero Liability Protection for unauthorized purchases (subject to Mastercard guidelines)See MoreSee Rates and FeesAPPLY NOWon iCommissions Credit Cards's 
    secure websiteCredit Needed
    See website for Details*"

    "Marriott Bonvoy Bevy™ American Express® CardAbout Our RatingsRead our full reviewEarn 85,000 Marriott Bonvoy bonus points after you use your new Card to make $5,000 in purchases within the first 6 months of Card Membership.Earn 6X Marriott Bonvoy® points for each dollar of eligible purchases at hotels participating in Marriott Bonvoy.Earn 4X points at restaurants worldwide and U.S. supermarkets (on up to $15,000 in combined purchases at restaurants and U.S. supermarkets per calendar year, then 2X points).Earn 85,000 Marriott Bonvoy bonus points after you use your new Card to make $5,000 in purchases within the first 6 months of Card Membership.Earn 6X Marriott Bonvoy® points for each dollar of eligible purchases at hotels participating in Marriott Bonvoy.Earn 4X points at restaurants worldwide and U.S. supermarkets (on up to $15,000 in combined purchases at restaurants and U.S. supermarkets per calendar year, then 2X points).Earn 2X points on all other eligible purchases with the Marriott Bonvoy Bevy™ Card.Marriott Bonvoy 1K Bonus Points Per Stay: Earn 1,000 Marriott Bonvoy® bonus points per paid eligible stay booked directly with Marriott for properties participating in Marriott Bonvoy.With complimentary Marriott Bonvoy Gold Elites status, earn up to 2.5X points from Marriott Bonvoy® on eligible hotel purchases with the 25% Bonus Points on stays benefit, available for Qualifying Rates.Marriott Bonvoy Bevy Free Night Award: Earn 1 Free Night Award after spending $15,000 on eligible purchases on your Marriott Bonvoy Bevy™ Card in a calendar year. Award can be used for one night (redemption level at or under 50,000 Marriott Bonvoy® points) at a hotel participating in Marriott Bonvoy®. Certain hotels have resort fees.15 Elite Night Credits: Each calendar year with your Marriott Bonvoy Bevy™ American Express Card® you can receive 15 Elite Night Credits toward the next level of Marriott Bonvoy® Elite status. Limitations apply per Marriott Bonvoy member account. Benefit is not exclusive to Cards offered by American Express. Terms apply.Plan It® is a payment option that lets you split up purchases of $100 or more into equal monthly installments with a fixed fee. Plus, you'll still earn rewards the way you usually do.$250 Annual Fee.Apply with confidence. Know if you're approved for a Card with no impact to your credit score. If you're approved and you choose to accept this Card, your credit score may be impacted.Terms Apply.See MoreSee Rates and Fees; terms applyAPPLY NOWon American Express (Impact Radius)'s 
    secure websiteCredit Needed
    Good, Excellent"

    "Marriott Bonvoy Brilliant® American Express® CardAbout Our RatingsRead our full reviewEarn 95,000 Marriott Bonvoy® bonus points after you use your new Card to make $6,000 in purchases within the first 6 months of Card Membership.$300 Brilliant Dining Credit: Each calendar year, get up to $300 (up to $25 per month) in statement credits for eligible purchases made on the Marriott Bonvoy Brilliant® American Express® Card at restaurants worldwide.With Marriott Bonvoy Platinum Elite status, you can receive room upgrades, including enhanced views or suites, when available at select properties and booked with a Qualifying Rate.Earn 95,000 Marriott Bonvoy® bonus points after you use your new Card to make $6,000 in purchases within the first 6 months of Card Membership.$300 Brilliant Dining Credit: Each calendar year, get up to $300 (up to $25 per month) in statement credits for eligible purchases made on the Marriott Bonvoy Brilliant® American Express® Card at restaurants worldwide.With Marriott Bonvoy Platinum Elite status, you can receive room upgrades, including enhanced views or suites, when available at select properties and booked with a Qualifying Rate.Earn 6X Marriott Bonvoy® points for each dollar of eligible purchases at hotels participating in Marriott Bonvoy®. Earn 3X Marriott Bonvoy® points at restaurants worldwide and on flights booked directly with airlines and 2X Marriott Bonvoy® points on all other eligible purchases made on the Marriott Bonvoy Brilliant® American Express® Card.Free Night Award: Receive 1 Free Night Award every year after your Card renewal month. Award can be used for one night (redemption level at or under 85,000 Marriott Bonvoy points) at hotels participating in Marriott Bonvoy®. Certain hotels have resort fees.Each calendar year after spending $60,000 on eligible purchases on your Marriott Bonvoy Brilliant® American Express® Card, you will be eligible to select a Brilliant Earned Choice Award benefit. You can only earn one Earned Choice Award per calendar year. See https://www.choice-benefit.marriott.com/brilliant for Award options.$100 Marriott Bonvoy Property Credit: Enjoy your stay. Receive up to a $100 property credit for qualifying charges at The Ritz-Carlton® or St. Regis® when you book direct using a special rate for a two-night minimum stay using your Card.Fee Credit for Global Entry or TSA PreCheck®: Receive either a statement credit every 4 years after you apply for Global Entry ($120) or a statement credit every 4.5 years after you apply for a five-year membership for TSA PreCheck® (up to $85 through a TSA PreCheck official enrollment provider) and pay the application fee with your Marriott Bonvoy Brilliant® American Express® Card. If approved for Global Entry, at no additional charge, you will receive access to TSA PreCheck.Each calendar year with your Marriott Bonvoy Brilliant® American Express® Card you can receive 25 Elite Night Credits toward the next level of Marriott Bonvoy® Elite status. Limitations apply per Marriott Bonvoy member account. Benefit is not exclusive to Cards offered by American Express.Enroll in Priority Pass™ Select, which offers unlimited airport lounge visits to over 1,200 lounges in over 130 countries, regardless of which carrier or class you are flying. This allows you to relax before or between flights. You can enjoy snacks, drinks, and internet access in a quiet, comfortable location.No Foreign Transaction Fees on international purchases.With Cell Phone Protection, you can be reimbursed, the lesser of, your repair or replacement costs following damage, such as a cracked screen, or theft for a maximum of $800 per claim when your cell phone line is listed on a wireless bill and the prior month's wireless bill was paid by an Eligible Card Account. A $50 deductible will apply to each approved claim with a limit of 2 approved claims per 12-month period. Additional terms and conditions apply. Coverage is provided by New Hampshire Insurance Company, an AIG Company.$650 Annual Fee.Apply with confidence. Know if you're approved for a Card with no impact to your credit score. If you're approved and you choose to accept this Card, your credit score may be impacted.Terms Apply.See MoreSee Rates and Fees; terms applyAPPLY NOWon American Express (Impact Radius)'s 
    secure websiteCredit Needed
    Good, Excellent"

    """
    transactions_str = "\n".join([str(t) for t in transactions[:10]])

    # Run the chain
    result = chain.run({
        "credit_cards": credit_cards_str,
        "transactions": transactions_str
    })
    print("Hello")
    print(result)

    parsed_cards = parse_card_recommendations(result)

    print(parsed_cards)

    return parsed_cards


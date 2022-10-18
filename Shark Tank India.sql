SELECT
    *
FROM
    shark_tank;

--Total Number of episodes
SELECT
    COUNT(DISTINCT ep_no)
FROM
    shark_tank;
--or another method
SELECT
    MAX(ep_no)
FROM
    shark_tank;

--Total number of different brand names listed
SELECT
    COUNT(DISTINCT brand)
FROM
    shark_tank;

--List of startups got funded and got rejected
SELECT
    amount_invested_lakhs,
    CASE
        WHEN amount_invested_lakhs > 0 THEN
            1
        ELSE
            0
    END AS listed_startups
FROM
    shark_tank;
--1 as frunded startups & 0 as not funded startups


--Number of Funded Startups
SELECT
    SUM(a.listed_startups) funded_startup,
    COUNT(*)               total_startups
FROM
    (
        SELECT
            amount_invested_lakhs,
            CASE
                WHEN amount_invested_lakhs > 0 THEN
                    1
                ELSE
                    0
            END AS listed_startups
        FROM
            shark_tank
    ) a;
--or another procedure
SELECT
    COUNT(amount_invested_lakhs) AS funded_startups
FROM
    shark_tank
WHERE
    amount_invested_lakhs <> 0;
    
--Number of Not Funded Startups
SELECT
    COUNT(amount_invested_lakhs) AS not_funded_startups
FROM
    shark_tank
WHERE
    amount_invested_lakhs = 0;

--Percentage of Funded Sartups (in rounded value) in the whole show 
SELECT
    round(SUM(a.listed_startups) / COUNT(*) * 100) success_startups_percentage
FROM
    (
        SELECT
            amount_invested_lakhs,
            CASE
                WHEN amount_invested_lakhs > 0 THEN
                    1
                ELSE
                    0
            END AS listed_startups
        FROM
            shark_tank
    ) a;
    
--Total number of male and female participants
SELECT
    SUM(male)   AS male_participants,
    SUM(female) AS female_participants
FROM
    shark_tank;

--Percentage of female, comparison to male participants
SELECT
    round(SUM(female) / SUM(male) * 100)
FROM
    shark_tank;

--Average Equity taken by the Sharks in the show
SELECT
    round(AVG(a.equity_taken_percent))
FROM
    (
        SELECT
            equity_taken_percent
        FROM
            shark_tank
        WHERE
            equity_taken_percent > 0
    ) a;

--Highest deals taken
SELECT
    MAX(amount_invested_lakhs) AS highest_deal
FROM
    shark_tank;

--Highest equity taken
SELECT
    MAX(equity_taken_percent) AS highest_equity
FROM
    shark_tank;

--Number of funded startups which is from a female participants
SELECT
    SUM(female) AS femlae_funded_startups
FROM
    shark_tank
WHERE
    amount_invested_lakhs > 0;

--List of funded startups, which is from a male participants
SELECT
    male,
    deal,
    amount_invested_lakhs
FROM
    shark_tank
WHERE
    amount_invested_lakhs > 0;

--Average team members
SELECT
    AVG(team_members)
FROM
    shark_tank;

--Average amounts invested by the Sharks
SELECT
    AVG(amount_invested_lakhs) AS avg_amount_invested_lakhs
FROM
    shark_tank
WHERE
    deal <> 'No Deal';

--Average age groups of participants
SELECT
    avg_age,
    COUNT(avg_age) AS participants_avg_age
FROM
    shark_tank
WHERE
    avg_age IS NOT NULL
GROUP BY
    avg_age
ORDER BY
    avg_age;

-- Number of locations from where participants come
SELECT
    location,
    COUNT(location) AS participants_location
FROM
    shark_tank
WHERE
    location IS NOT NULL
GROUP BY
    location
ORDER BY
    participants_location DESC;

--Number of ideas on differents sectors
SELECT
    sector,
    COUNT(sector) AS sector_of_ideas
FROM
    shark_tank
WHERE
    sector IS NOT NULL
GROUP BY
    sector
ORDER BY
    sector_of_ideas DESC;

--Number of partnerships  
SELECT
    partners,
    COUNT(partners) AS number_of_partnerships
FROM
    shark_tank
WHERE
    total_investors <> 0
GROUP BY
    partners
ORDER BY
    number_of_partnerships DESC;
    
--
select * from shark_tank_data;

--Deatils of deals made by Anupam
select anupam_amount_invested from shark_tank where anupam_amount_invested >0;
select count(anupam_amount_invested) as deal_by_anupam from shark_tank where anupam_amount_invested <>0;
select sum(anupam_amount_invested) as total_investment, avg(anupam_amount_invested) as avg_investment from shark_tank where anupam_amount_invested >0;
select avg(anupam_equity_taken_percent) as avg_equity from shark_tank where anupam_equity_taken_percent is not null and anupam_equity_taken_percent<>0;

--Details of Anupam's Deal on Tabular form
SELECT
    m.keyy,
    m.total_deals,
    m.anupams_deals,
    n.total_investment,
    n.avg_equity
FROM
         (
        SELECT
            a.keyy,
            a.total_deals,
            b.anupams_deals
        FROM
                 (
                SELECT
                    'anupam'                      AS keyy,
                    COUNT(anupam_amount_invested) AS total_deals
                FROM
                    shark_tank
                WHERE
                    anupam_amount_invested IS NOT NULL
            ) a
            INNER JOIN (
                SELECT
                    'anupam'                      AS keyy,
                    COUNT(anupam_amount_invested) AS anupams_deals
                FROM
                    shark_tank
                WHERE
                    anupam_amount_invested IS NOT NULL
                    AND anupam_amount_invested > 0
            ) b ON a.keyy = b.keyy
    ) m
    INNER JOIN (
        SELECT
            'anupam'                           AS keyy,
            SUM(c.anupam_amount_invested)      AS total_investment,
            AVG(c.anupam_equity_taken_percent) AS avg_equity
        FROM
            (
                SELECT
                    *
                FROM
                    shark_tank
                WHERE
                        anupam_amount_invested > 0
                    AND anupam_equity_taken_percent IS NOT NULL
            ) c
    ) n ON m.keyy = n.keyy;

--Sector wise Investment with rank
SELECT
    sector,
    brand,
    amount_invested_lakhs,
    RANK()
    OVER(PARTITION BY sector
         ORDER BY
             amount_invested_lakhs DESC
    ) AS rank_by_investment
FROM
    shark_tank;

--Top ranked Brands in each Sector
SELECT
    p.brand,
    p.sector,
    p.amount_invested_lakhs
FROM
    (
        SELECT
            sector,
            brand,
            amount_invested_lakhs,
            RANK()
            OVER(PARTITION BY sector
                 ORDER BY
                     amount_invested_lakhs DESC
            ) AS rank_by_investment
        FROM
            shark_tank
    ) p
WHERE
        p.rank_by_investment = 1
    AND p.amount_invested_lakhs IS NOT NULL;
    
    
    
    
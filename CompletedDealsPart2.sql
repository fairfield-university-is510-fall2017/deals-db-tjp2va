# 2. Test query Indicate that we are using the deals database
USE deals;
# Execute a test query
SELECT *
FROM Companies
WHERE CompanyName like "%Inc.";

# 3. Add a new query to the bottom of the script that sorts companies by CompanyID 
# Select companies sorted by CompanyName
SELECT *
FROM Companies
ORDER BY CompanyID;

# 5 Use a where clause to merge data from multiple tables.
# Select Deals Parts with dollar values
SELECT DealName, PartNumber, DollarValue
FROM Deals, dealparts
WHERE Deals.DealID = DealParts.DealID;

#6  Repeat the multi-table query but using JOIN ON instead of WHERE to match records in the two tables.
# Select Deal Parts with dollar values using a join
SELECT DEALS.DealName, DEALPARTS.PartNumber, DEALPARTS.DollarValue
FROM DEALS
	join DealParts on (Deals.DealID=DealParts.DealID);

# 7. Study the database schema to see more opportunities to join table
SELECT DEALS.DealName, PLAYERS.RoleCode, COMPANIES.CompanyName
FROM COMPANIES 
	JOIN PLAYERS ON (Companies.CompanyID = PLAYERS.CompanyID)
	JOIN DEALS ON (PLAYERS.DealID = DEALS.DealID)
ORDER BY DealName;

# 8 Create a reusable view based on the previous select query.
DROP VIEW IF EXISTS CompanyDeals;
CREATE VIEW CompanyDeals AS
SELECT DEALS.DealName, PLAYERS.RoleCode, COMPANIES.CompanyName
FROM COMPANIES 
	JOIN PLAYERS ON (Companies.CompanyID = PLAYERS.CompanyID)
	JOIN DEALS ON (PLAYERS.DealID = DEALS.DealID)
ORDER BY DealName;

# 9 Create a view named DealValues that lists the DealID, total dollar value and number of parts for each deal.
DROP VIEW IF EXISTS DealValues;
CREATE VIEW DealValues AS
SELECT DEALS.DealID, SUM(DollarValue) AS TotDollarValue, COUNT(PartNumber) AS NumParts
FROM DEALS JOIN DEALPARTS ON (DEALS.DealID = DEALPARTS.DealID)
GROUP BY DEALS.DealID
ORDER BY DEALS.DealID;

SELECT * from DealValues;


# 10 Create a view named DealSummary that lists the DealID, DealName, number of players, total dollar value, and number of parts for each deal.
SELECT DEALS.DealID, DealName, COUNT(PlayerID) AS NumPlayers, TotDollarValue, NumParts
FROM DEALS JOIN DealValues ON (DEALS.DealID = DealValues.DealID) 
			JOIN Players ON (DEALS.DealID = Players.DealID)
GROUP BY Deals.DealID;

# 11 
DROP VIEW IF EXISTS DealsByType;
CREATE VIEW DealsByType AS
SELECT DISTINCT DealTypes.TypeCode, COUNT(Deals.DealID) AS NumDeals, SUM(DealParts.DollarValue) as TotDollarValue
FROM DealTypes 
	LEFT JOIN Deals ON (DealTypes.DealID = Deals.DealID) 
	JOIN DealParts ON (DealParts.DealID = Deals.DealID)
GROUP BY DealTypes.TypeCode;

# 12 Create a view called DealPlayers that lists the CompanyID, Name, and Role Code for each deal. Sort the players by the RoleSortOrder.
DROP VIEW IF EXISTS DealPlayers;
CREATE VIEW DealPlayers AS
SELECT DealID, CompanyID, CompanyName, RoleCode
FROM Players 
	JOIN Deals USING (DealID)
    JOIN COMPANIES USING (CompanyID)
    JOIN ROLECODES USING (ROLECODE)
ORDER BY RoleSortOrder;

# 13 Create a view called DealsByFirm that lists the FirmID, Name, number of deals, and total value of deals for each firm.
# Each firm should be listed, even if there are no deals for that firm. (Don't forget the comment and the select query.)
SELECT FirmID, Firms.Name, COUNT(PLAYERS.DealId) AS NumDeals, SUM(TotDollarValue) AS TotValue
FROM FIRMS 
	JOIN PLAYERSUPPORTS USING (FirmID)
	JOIN PLAYERS USING (PlayerID)
	JOIN DealValues USING (DealID)
GROUP BY FirmID;
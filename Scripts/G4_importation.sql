

INSERT into TAG (NAME, DESCRIPTION, TREND_STATUS)
SELECT DISTINCT HASHTAG, HASHTAG_DESC, TRENDING_STATUS
FROM DS3_POSTS;

INSERT INTO IMAGE (PATH, MIME) 
SELECT DISTINCT PATH, mime
FROM DS3_POSTS;

INSERT INTO COUNTRY (COUNTRY_NAME)
SELECT DISTINCT SUBSTR(GG.PLACE, INSTR(GG.PLACE, ',') + 1)
FROM (SELECT
		HOME_CITY AS place
	FROM ds1_match

	UNION ALL

	SELECT
		AWAY_CITY AS place
	FROM ds1_match
	
	UNION ALL
	SELECT CITY AS PLACE 
	FROM DS1_MATCH
	
	UNION ALL
	SELECT HOME_MANAGER_CITY AS PLACE 
	FROM DS1_MATCH
	
	UNION ALL
	SELECT AWAY_MANAGER_CITY AS PLACE 
	FROM DS1_MATCH
	
	UNION ALL
	  SELECT
		CITY AS place
	FROM ds1_players
	WHERE CITY <> 'es' 
	
	UNION ALL 
	select 
		localization as place 
	from ds3_posts
	UNION ALL
	
	SELECT SUBSTR(dps.city,INSTR(dps.city,',')+1) as place
	FROM DS2_PRODUCT_SALES dps
	where dps.city is not null) gg;
	
INSERT INTO CITY(CITY_NAME, COUNTRY_NAME)
SELECT DISTINCT SUBSTR(gg.place, 1, INSTR(gg.place, ',') - 1) as city_name, SUBSTR(gg.place, INSTR(gg.place, ',') + 1) as country_name
FROM (
	SELECT
		HOME_CITY AS place
	FROM ds1_match

	UNION ALL

	SELECT
		AWAY_CITY AS place
	FROM ds1_match
	
	UNION ALL
	SELECT CITY AS PLACE 
	FROM DS1_MATCH
	
	UNION ALL
	SELECT HOME_MANAGER_CITY AS PLACE 
	FROM DS1_MATCH
	
	UNION ALL
	SELECT AWAY_MANAGER_CITY AS PLACE 
	FROM DS1_MATCH
	
	UNION ALL
	  SELECT
		CITY AS place
	FROM ds1_players
	WHERE CITY <> 'es' 
	
	UNION ALL 
	select 
		localization as place 
	from ds3_posts gg
	
	UNION ALL
	
	SELECT DPS.CITY AS PLACE
	FROM DS2_PRODUCT_SALES dps
	where dps.city is not null 
	
	UNION ALL
		SELECT City AS place
	FROM DS4_ADS )gg
;
--

INSERT INTO USERTABLE (NAME, city_id, VERIFIED, CREATION_DATE) 
SELECT DISTINCT NICKNAME, c.city_id, VERIFIED, CREATION_DATE
FROM DS3_POSTS
join city c on c.city_name = SUBSTR(Localization, 1, INSTR(LOCALIZATION, ',') - 1) AND C.COUNTRY_NAME = SUBSTR(LOCALIZATION, INSTR(LOCALIZATION, ',') + 1);

INSERT INTO POST (POST_ID, POSTTEXT, CREATION_DATE, LIKES, REPOSTS, FK_USER) 
SELECT DISTINCT POST_ID, POST, CREATION_DATE, LIKES, REPOSTS, NICKNAME
FROM DS3_POSTS;

INSERT INTO HASHTAGPOST (POST_ID, HASHTAG)
SELECT DISTINCT POST_ID, HASHTAG 
FROM DS3_POSTS
WHERE HASHTAG IS NOT NULL;

INSERT INTO IMAGEPOST (POST_ID, IMAGE_PATH, TITLE)
SELECT POST_ID, PATH, IMAGE
FROM DS3_POSTS;

INSERT INTO REPLY(POST_ID, REPLY_TO)
SELECT DISTINCT POST_ID, REPLY_TO
FROM DS3_POSTS
WHERE REPLY_TO IS NOT NULL;

INSERT INTO MEDIA_GROUP (NAME, DESCRIPTION, FK_HQ_City_ID) -- AUTOMATIC ID GENERATED
SELECT DISTINCT d.NAME_OF_MEDIA_GROUP, d.DESCRIPTION_OF_MEDIA_GROUP, c.city_id
FROM DS3_RADIOS d
join city c on c.CITY_NAME = d.HEADQUARTERS_OF_THE_MEDIA_GROUP;

INSERT INTO TV_CHANNEL (NAME, VIDEOQUALITY, fk_id_group) -- AUTOMATIC ID GENERATED
SELECT DISTINCT
	r.TITLE_OF_THE_TV_CHANNEL,
	r.VIDEO_QUALITY_OF_THE_TV_CHANNEL,
	mg.ID_GROUP
FROM DS3_tvs r
JOIN MEDIA_GROUP mg ON r.NAME_OF_MEDIA_GROUP = mg.NAME;
	-- maybe tv channel does not have all entries because
INSERT INTO PROGRAMME(NAME, DESCRIPTION, LSSL, SCHEDULE) -- AUTOMATIC ID GENERATED
SELECT DISTINCT d.PROGRAMME, d.DESCRIPTION, d.PROGRAMME_LSSL, d.SCHEDULE
FROM DS3_TVS d
JOIN TV_CHANNEL tvc ON tvc.name = d.TITLE_OF_THE_TV_CHANNEL;



INSERT INTO TV_PROGRAMME(ID_TV_PROGRAM, PROD_COMPANY, FK_CHANNEL_ID)
SELECT DISTINCT pg.ID_PROGRAM, rp.PRODUCTION_COMPANY, tvc.CHANNEL_ID
FROM DS3_TVS rp
JOIN PROGRAMME pg ON rp.PROGRAMME = pg.NAME
JOIN TV_CHANNEL tvc ON tvc.name = rp.TITLE_OF_THE_TV_CHANNEL;


INSERT INTO PERSON (NAME_PERSON, SURNAME, GENDER, DATE_OF_BIRTH)
SELECT DISTINCT 
	FIRSTNAME, 
	LASTNAME, 
	GENDER,
	BIRTHDATE
FROM DS3_TVS t
WHERE NOT EXISTS (
	SELECT 1 
	FROM PERSON p
	WHERE p.NAME_PERSON = t.FIRSTNAME
	  AND p.SURNAME = t.LASTNAME
	  AND p.GENDER = t.GENDER
	  AND P.DATE_OF_BIRTH = T.BIRTHDATE
);




INSERT INTO PARTICIPATES (ID_PERSON, ID_PROGRAM, SPECIALIZATION) 
SELECT DISTINCT p.PERSONID, pr.ID_PROGRAM, ROLE
FROM DS3_TVS rp
JOIN PERSON p on p.NAME_PERSON = rp.FIRSTNAME AND p.SURNAME = rp.LASTNAME
JOIN PROGRAMME pr on pr.NAME = rp.PROGRAMME;

INSERT INTO RADIO_STATION (NAME, DESCRIPTION, FK_ID_GROUP,BROADCAST_FREQUENCY)
SELECT DISTINCT
	r.NAME_OF_THE_RADIO_STATION,
	DESCRIPTION_OF_THE_RADIO_STATION,
	mg.ID_GROUP,
	FREQUENCY_OF_THE_RADIO_STATION
FROM DS3_RADIOS r
LEFT JOIN MEDIA_GROUP mg ON r.NAME_OF_MEDIA_GROUP = mg.NAME;

INSERT INTO PROGRAMME(NAME, DESCRIPTION, LSSL, SCHEDULE)
SELECT DISTINCT PROGRAMME, DESCRIPTION, PROGRAMME_LSSL, SCHEDULE
FROM DS3_RADIOS;

INSERT INTO RADIO_PROGRAMME(ID_RADIO_PROGRAM, ASS_PODCAST, FK_RADIO_STATION)
SELECT DISTINCT pg.ID_PROGRAM, rp.PODCAST, tvc.RS_ID 
FROM DS3_RADIOS rp
JOIN PROGRAMME pg ON rp.PROGRAMME = pg.NAME
JOIN RADIO_STATION tvc ON tvc.name = rp.NAME_OF_THE_RADIO_STATION;


INSERT INTO PERSON (NAME_PERSON, SURNAME, GENDER, date_of_birth) 
SELECT DISTINCT 
	FIRSTNAME, 
	LASTNAME, 
	GENDER,
	birthdate
FROM DS3_RADIOS r
WHERE NOT EXISTS (
	SELECT 1 
	FROM PERSON p
	WHERE p.NAME_PERSON = r.FIRSTNAME
	  AND p.SURNAME = r.LASTNAME
	  AND p.GENDER = r.GENDER
	  and p.date_of_birth = r.birthdate
);

INSERT INTO PARTICIPATES (ID_PERSON, ID_PROGRAM, SPECIALIZATION) 
SELECT DISTINCT p.PERSONID, pr.ID_PROGRAM, ROLE
FROM DS3_RADIOS rp
JOIN PERSON p on p.NAME_PERSON = rp.FIRSTNAME AND p.SURNAME = rp.LASTNAME
JOIN PROGRAMME pr on pr.NAME = rp.PROGRAMME;




INSERT INTO PERSON (NAME_PERSON, SURNAME, DATE_OF_BIRTH)
SELECT DISTINCT 
	SUBSTR(p.NAME, 1, INSTR(p.NAME, ' ') - 1) AS NAME_PERSON,
	SUBSTR(p.NAME, INSTR(p.NAME, ' ') + 1) AS SURNAME,
	p.BIRTHDATE AS DATE_OF_BIRTH
FROM DS1_PLAYERS p
WHERE NOT EXISTS (
	SELECT 1 
	FROM PERSON pr
	WHERE pr.NAME_PERSON = SUBSTR(p.NAME, 1, INSTR(p.NAME, ' ') - 1)
	  AND pr.SURNAME = SUBSTR(p.NAME, INSTR(p.NAME, ' ') + 1)
	  AND pr.DATE_OF_BIRTH = p.BIRTHDATE
);


INSERT INTO PLAYER (PlayerID, Height, Weight, Footed)
SELECT DISTINCT p.PERSONID, pl.Height, pl.Weight, pl.Footed
FROM DS1_PLAYERS pl
JOIN PERSON p ON p.Name_person = SUBSTR(pl.NAME, 1, INSTR(pl.NAME, ' ') - 1) and p.surname =  SUBSTR(pl.NAME, INSTR(pl.NAME, ' ') + 1) AND p.DATE_OF_BIRTH = pl.BIRTHDATE;

INSERT INTO PERSON (NAME_PERSON, SURNAME)
SELECT DISTINCT 
	SUBSTR(referee_name, 1, INSTR(referee_name, ' ') - 1) AS NAME_PERSON,
	SUBSTR(referee_name, INSTR(referee_name, ' ') + 1) AS SURNAME
FROM (
	SELECT REFEREE AS referee_name FROM ds1_match
	UNION ALL
	SELECT AR1 AS referee_name FROM ds1_match
	UNION ALL
	SELECT AR2 AS referee_name FROM ds1_match
	UNION ALL
	SELECT FOURTH AS referee_name FROM ds1_match
	UNION ALL
	SELECT VAR AS referee_name FROM ds1_match
) r
WHERE NOT EXISTS (
	SELECT 1 
	FROM PERSON p
	WHERE p.NAME_PERSON = SUBSTR(r.referee_name, 1, INSTR(r.referee_name, ' ') - 1)
	  AND p.SURNAME = SUBSTR(r.referee_name, INSTR(r.referee_name, ' ') + 1)
);

INSERT INTO referee (RefereeID, certification)
SELECT DISTINCT 
	p.PersonID AS RefereeID,
	r.certification
FROM (
	SELECT 
		REFEREE AS referee_name,
		REFEREE_CERT AS certification
	FROM ds1_match

	UNION ALL

	SELECT 
		AR1 AS referee_name,
		AR1_CERT AS certification
	FROM ds1_match

	UNION ALL

	SELECT 
		AR2 AS referee_name,
		AR2_CERT AS certification
	FROM ds1_match

	UNION ALL

	SELECT 
		FOURTH AS referee_name,
		FOURTH_CERT AS certification
	FROM ds1_match

	UNION ALL

	SELECT 
		VAR AS referee_name,
		VAR_CERT AS certification
	FROM ds1_match
) r
JOIN person p ON p.Name_person = SUBSTR(r.referee_name, 1, INSTR(r.referee_name, ' ') - 1) 
			  AND p.surname =  SUBSTR(r.referee_name, INSTR(r.referee_name, ' ') + 1);

INSERT INTO PERSON (NAME_PERSON, SURNAME, GENDER, DATE_OF_BIRTH)
SELECT DISTINCT 
	SUBSTR(manager_name, 1, INSTR(manager_name, ' ') - 1) AS NAME_PERSON,
	SUBSTR(manager_name, INSTR(manager_name, ' ') + 1) AS SURNAME,
	gender,
	date_of_birth
FROM (
	SELECT 
		HOME_MANAGER AS manager_name,
		HOME_GENDER AS gender,
		HOME_DATE AS date_of_birth
	FROM ds1_match

	UNION ALL

	SELECT AWAY_MANAGER AS manager_name,
		AWAY_GENDER AS gender,
		AWAY_DATE AS date_of_birth
	FROM ds1_match
) m
WHERE NOT EXISTS (
	SELECT 1 
	FROM PERSON p
	WHERE p.NAME_PERSON = SUBSTR(m.manager_name, 1, INSTR(m.manager_name, ' ') - 1)
	  AND p.SURNAME = SUBSTR(m.manager_name, INSTR(m.manager_name, ' ') + 1)
	  AND p.GENDER = m.gender
	  AND p.DATE_OF_BIRTH = m.date_of_birth
);

INSERT INTO coach (CoachID, TrainingStyle) 
SELECT DISTINCT 
	p.PersonID AS CoachID,
	c.TrainingStyle
FROM (
	SELECT 
		HOME_MANAGER AS manager_name,
		HOME_STYLE AS TrainingStyle,
		HOME_TACTICS AS Tactics,
		HOME_DATE AS date_of_birth,
		HOME_GENDER AS gender
	FROM ds1_match

	UNION ALL

	SELECT 
		AWAY_MANAGER AS manager_name,
		AWAY_STYLE AS TrainingStyle,
		AWAY_TACTICS AS Tactics,
		AWAY_DATE AS date_of_birth,
		AWAY_GENDER AS gender
	FROM ds1_match
) c
JOIN person p ON p.Name_person = SUBSTR(c.manager_name, 1, INSTR(c.manager_name, ' ') - 1) 
			  AND p.surname =  SUBSTR(c.manager_name, INSTR(c.manager_name, ' ') + 1);

INSERT INTO coachTactics (Coach_ID, Tactics)
SELECT DISTINCT 
	p.PersonID AS CoachID,
	c.Tactics
FROM (
	SELECT 
		HOME_MANAGER AS manager_name,
		HOME_STYLE AS TrainingStyle,
		HOME_TACTICS AS Tactics,
		HOME_DATE AS date_of_birth,
		HOME_GENDER AS gender
	FROM ds1_match

	UNION ALL

	SELECT 
		AWAY_MANAGER AS manager_name,
		AWAY_STYLE AS TrainingStyle,
		AWAY_TACTICS AS Tactics,
		AWAY_DATE AS date_of_birth,
		AWAY_GENDER AS gender
	FROM ds1_match
) c
JOIN person p ON p.Name_person = SUBSTR(c.manager_name, 1, INSTR(c.manager_name, ' ') - 1) 
			  AND p.surname = SUBSTR(c.manager_name, INSTR(c.manager_name, ' ') + 1);


INSERT INTO CLUB (ClubID, City_ID)
SELECT DISTINCT
	club.ClubID,
	C.City_ID
FROM(
	SELECT
		HOME AS ClubID,
		HOME_CITY AS CITYNAME
	FROM ds1_match

	UNION ALL

	SELECT
		AWAY AS ClubID,
		AWAY_CITY AS CITYNAME
	FROM ds1_match
	
) club
join City c on c.City_name = SUBSTR(cityname, 1, INSTR(cityname, ',') - 1) and c.Country_name = SUBSTR(cityname, INSTR(cityname, ',') + 1);


INSERT INTO matchesT (
	MatchID, Match_date, Local_club, Visitor_club, Local_poss, Visitor_poss,
	Local_manager, Visitor_manager, Venue, Attendance, Match_city,Goals_local, Goals_visitor, season, competition_id
)
SELECT 
	m.MATCH_ID,
	m.MATCH_DATE,
	m.HOME, 
	m.AWAY, 
	m.HOME_POSS, 
	m.AWAY_POSS, 
	p.personid AS Local_manager,
	f.personid AS Visitor_manager,
	m.VENUE, 
	m.ATTENDANCE,
	c.CITY_ID,
	0 AS Goals_local,
	
	0 AS Goals_visitor,
     m.season,
     m.league

FROM 
	ds1_match m
JOIN  PERSON p ON 
	SUBSTR(m.HOME_MANAGER, 1, INSTR(m.HOME_MANAGER, ' ') - 1) = p.NAME_PERSON AND 
	SUBSTR(m.HOME_MANAGER, INSTR(m.HOME_MANAGER, ' ') + 1) = p.SURNAME AND 
	p.DATE_OF_BIRTH = HOME_DATE
JOIN  PERSON f ON 
	SUBSTR(m.AWAY_MANAGER, 1, INSTR(m.AWAY_MANAGER, ' ') - 1) = f.NAME_PERSON AND 
	SUBSTR(m.AWAY_MANAGER, INSTR(m.AWAY_MANAGER, ' ') + 1) = f.SURNAME AND 
	f.DATE_OF_BIRTH = AWAY_DATE
JOIN City c on c.City_name = SUBSTR(m.CITY, 1, INSTR(m.CITY, ',') - 1) and c.Country_name = SUBSTR(M.CITY, INSTR(M.CITY, ',') + 1) or m.city is null;

INSERT INTO plays (PlayerID, MatchID, Club, Goals, Position, Shots, Shots_on_target, Assists, YellowCards, RedCards)
SELECT DISTINCT 
	p.PersonID,
	d.match_id,
	d.club,
	d.Goals,
	d.Position,
	d.Shots,
	d.Shots_on_target,
	d.Assists,
	d.Yellow_Cards,
	d.Red_Cards
	
FROM
	ds1_players d
JOIN person p ON p.Name_person = SUBSTR(d.NAME, 1, INSTR(d.NAME, ' ') - 1) AND p.surname = SUBSTR(d.NAME, INSTR(d.NAME, ' ') + 1) AND p.DATE_OF_BIRTH = d.BIRTHDATE
where d.city is not null; -- works

UPDATE matchesT m
SET 
	m.Goals_local = COALESCE(
		(SELECT SUM(pl.Goals)
		 FROM plays pl
		 WHERE pl.club = m.Local_club AND pl.matchid = m.MatchID), 
		0),
	m.Goals_visitor = COALESCE(
		(SELECT SUM(pl.Goals)
		 FROM plays pl
		 WHERE pl.club = m.Visitor_club AND pl.matchid = m.MatchID), 
		0)
WHERE EXISTS (
	SELECT 1
	FROM plays pl
	WHERE pl.matchid = m.matchid
);


INSERT INTO competition (CompetitionID, gender)
SELECT DISTINCT LEAGUE, GENDER
FROM ds1_match;

INSERT INTO compete (ClubID, CompetitionID, Season) 
SELECT DISTINCT
	c.ClubID,
	c.CompetitionID,
	c.Season
FROM (
	SELECT
		HOME AS ClubID,
		LEAGUE AS CompetitionID,
		SEASON AS Season
	FROM ds1_match
	UNION ALL
	SELECT
		AWAY AS ClubID,
		LEAGUE AS CompetitionID,
		SEASON AS Season
	FROM ds1_match
) c
JOIN competition comp ON c.CompetitionID = comp.CompetitionID
JOIN club cl ON c.ClubID = cl.ClubID;

INSERT INTO HavePlayer (player_id, club_id, start_date, end_date) 
SELECT
	s.PlayerID,
	s.club_id,
	MIN(s.Match_date) AS start_date,
	MAX(s.Match_date) AS end_date
FROM (
	SELECT
		p.PlayerID,
		CASE
			WHEN m.Local_club = c.ClubID THEN m.Local_club
			WHEN m.Visitor_club = c.ClubID THEN m.Visitor_club
		END AS club_id,
		m.Match_date
	FROM
		plays pl
	JOIN
		player p ON pl.PlayerID = p.PlayerID
	JOIN
		matchesT m ON pl.MatchID = m.MatchID
	JOIN
		club c ON m.Local_club = c.ClubID OR m.Visitor_club = c.ClubID
) s
GROUP BY s.PlayerID, s.club_id;

INSERT INTO HaveCoach (club_id, coach_id, start_date, end_date) 
SELECT
	s.club_id,
	s.coach_id,
	MIN(s.Match_date) AS start_date,
	MAX(s.Match_date) AS end_date
FROM (
	SELECT
		CASE
			WHEN m.Local_club = c.ClubID THEN m.Local_club
			WHEN m.Visitor_club = c.ClubID THEN m.Visitor_club
		END AS club_id,
		CASE
			WHEN m.Local_club = c.ClubID THEN m.Local_manager
			WHEN m.Visitor_club = c.ClubID THEN m.Visitor_manager
		END AS coach_id,
		m.Match_date
	FROM
		matchesT m
	JOIN
		club c ON m.Local_club = c.ClubID OR m.Visitor_club = c.ClubID
) s
GROUP BY s.club_id, s.coach_id;


	

INSERT INTO controls (referee_id, match_id, roleRef)
SELECT
	p.PersonID AS referee_id,
	m.MATCHID AS match_id,
	r.roleRef
FROM (
	SELECT 
		REFEREE AS referee_name,
		'Main Referee' AS roleRef,
		MATCH_ID
	FROM ds1_match

	UNION ALL

	SELECT 
		AR1 AS referee_name,
		'Assistant Referee 1' AS roleRef,
		MATCH_ID
	FROM ds1_match

	UNION ALL

	SELECT 
		AR2 AS referee_name,
		'Assistant Referee 2' AS roleRef,
		MATCH_ID
	FROM ds1_match

	UNION ALL

	SELECT 
		FOURTH AS referee_name,
		'Fourth Official' AS roleRef,
		MATCH_ID
	FROM ds1_match

	UNION ALL

	SELECT 
		VAR AS referee_name,
		'VAR' AS roleRef,
		MATCH_ID
	FROM ds1_match
) r
JOIN person p ON p.Name_person = SUBSTR(r.referee_name, 1, INSTR(r.referee_name, ' ') - 1) AND p.surname =  SUBSTR(r.referee_name, INSTR(r.referee_name, ' ') + 1)
JOIN matchesT m ON m.MATCHID = r.MATCH_ID;


-- Insertion of the position of the Club to compete table
CREATE TABLE club_points_temp2 (
    ClubID VARCHAR2(255),
    Season VARCHAR2(255),
    CompetitionID VARCHAR2(255),
    Points INT
);

INSERT INTO club_points_temp2 (ClubID, Season, CompetitionID, Points)
SELECT 
    ma.Local_club, 
    ma.season,
    ma.Competition_ID, 
    CASE 
        WHEN ma.goals_Local > ma.goals_Visitor THEN 3
        WHEN ma.goals_Local = ma.goals_Visitor THEN 1
        ELSE 0
    END AS Points
FROM matchest ma
UNION ALL
SELECT 
    ma.Visitor_club, 
    ma.season,
    ma.Competition_ID, 
    CASE 
        WHEN ma.goals_Local < ma.goals_Visitor THEN 3
        WHEN ma.goals_Local = ma.goals_Visitor THEN 1
        ELSE 0
    END AS Points
FROM 
    matchesT ma;

CREATE TABLE aggregated_club_points2 (
    ClubID VARCHAR2(255),
    Season VARCHAR2(255),
    CompetitionID VARCHAR2(255),
    TotalPoints INT
);

INSERT INTO aggregated_club_points2 (ClubID, Season, CompetitionID, TotalPoints)
SELECT 
    ClubID, 
    Season, 
    CompetitionID, 
    SUM(Points) AS TotalPoints
FROM 
    club_points_temp2
GROUP BY 
    ClubID, 
    Season, 
    CompetitionID;

CREATE TABLE club_rankings_temp2 (
    ClubID VARCHAR2(255),
    Season VARCHAR2(255),
    CompetitionID VARCHAR2(255),
    Position INT
);

INSERT INTO club_rankings_temp2 (ClubID, Season, CompetitionID, Position)
SELECT 
    ClubID, 
    Season, 
    CompetitionID, 
    RANK() OVER (PARTITION BY Season, CompetitionID ORDER BY TotalPoints DESC) AS Position
FROM 
    aggregated_club_points2;

UPDATE compete c
SET Position = (
    SELECT Position
    FROM club_rankings_temp2 cr
    WHERE c.ClubID = cr.ClubID
      AND c.Season = cr.Season
      AND c.CompetitionID = cr.CompetitionID
);
drop table club_rankings_temp2;
drop table club_points_temp2;
drop table aggregated_club_points2;

-- Finalized update compete table to add position

INSERT INTO person (name_person, surname, gender, DATE_OF_BIRTH)
SELECT DISTINCT FirstName, LastName, Gender, BIRTHDATE
FROM ds2_shop_keepers r
WHERE NOT EXISTS (
	SELECT 1 
	FROM PERSON p
	WHERE p.NAME_PERSON = r.FIRSTNAME
	  AND p.SURNAME = r.LASTNAME
	  AND p.GENDER = r.GENDER
	  and p.date_of_birth = r.birthdate
);

INSERT INTO Activity (act_name, act_description)
SELECT DISTINCT Activity, Activity_description
FROM ds2_product_sales;


INSERT INTO Shop (name, description, City_ID)
SELECT DISTINCT dps.Shop, dps.Shop_description, city.City_ID
FROM ds2_product_sales dps
join city on SUBSTR(dps.city,1,INSTR(dps.city, ',')-1)=city.city_name and city.country_name=SUBSTR(dps.city,INSTR(dps.city,',')+1);

INSERT INTO Shopkeeper (ID_Shopkeeper, description, off_days)
SELECT DISTINCT p.PersonID, sk.FirstName || ' ' || sk.LastName, sk.vacation_days
FROM ds2_shop_keepers sk
JOIN person p ON sk.FirstName = p.name_person AND sk.LastName = p.surname AND P.DATE_OF_BIRTH=SK.BIRTHDATE
JOIN Shop s ON sk.Shop = s.name;


INSERT INTO SHOPKEEPERSHIFT(ID_Shopkeeper,shift, role ,ID_Shop)
SELECT DISTINCT p.PersonID, sk.shift, sk.role, s.ID_Shop
FROM ds2_shop_keepers sk
JOIN person p ON sk.FirstName = p.name_person AND sk.LastName = p.surname AND P.DATE_OF_BIRTH=SK.BIRTHDATE
JOIN Shop s ON sk.Shop = s.name;

INSERT INTO ProductType (pt_name, pt_description)
SELECT DISTINCT TYPE, Type_Description
FROM ds2_product_sales;


INSERT INTO Product (p_name, officiality, p_size, special_feature, p_use, type_closure, p_property, cloth_material, relevant_characteristic, ID_Activity, ClubID, ID_Type)
SELECT distinct p.Name, p.Official, p.Dimensions, p.Special_feature, p.Usage, p.Closure, p.Property, p.Material, p.Features, a.ID_Activity, c.ClubID, pt.ID_Type
FROM ds2_product_sales p
JOIN Activity a ON p.Activity = a.act_name
JOIN Club c ON p.Team = c.clubID
JOIN ProductType pt ON p.Type = pt.pt_name;

INSERT INTO sales (ID_Product, discount, credit_card_number,credit_card_EXPIRY_DATE, credit_card_PROVIDER, p_cost, p_units, p_purchaseDate, ID_shop)
SELECT p.ID_Product, DP.discount, CREDITCARD_NUM, CREDITCARD_EXPIRY, CREDITCARD_PROVIDER, dp.Total_cost, dp.Units, COALESCE(dp.PurchaseDate,'UNKNOWN'), s.ID_Shop
FROM ds2_product_sales dp
JOIN Product p ON dp.Name = p.p_name
join shop s on s.name = dp.shop
WHERE DP.PURCHASEDATE IS NOT NULL AND CREDITCARD_NUM IS NOT NULL;

INSERT INTO Inventory (ID_Product, ID_Shop, no_products)
SELECT distinct p.ID_Product, sh.ID_Shop, min(i.stock)        
FROM ds2_product_sales i
JOIN Product p ON i.Name = p.p_name
JOIN Shop sh ON i.Shop = sh.name group by p.ID_Product, sh.ID_Shop;

INSERT INTO Customer (Name, Basic_Address, Client_Budget, city_id)
SELECT DISTINCT d.client, c.city_id, d.client_budget, c.city_id FROM DS4_ADS d
JOIN CITY c ON c.city_name = SUBSTR (d.City, 1, INSTR(d.City, ',') - 1)
AND c.country_name =  SUBSTR(d.City, INSTR(d.City, ',') + 1);

INSERT INTO Campaign (Campaign_ID, Customer_ID, Name, Objective, Start_date, End_date, Budget) 
SELECT DISTINCT d.code, c.customer_id, d.campaign, d.objective, d.start_date, d.end_date, d.budget
FROM DS4_ADS d
JOIN Customer c ON c.name = d.client;

INSERT INTO productCampaign (ID_Campaign, ID_Product)
SELECT DISTINCT d.code, p.ID_Product
from ds4_ads d
join product p on p.p_name = d.product;

INSERT INTO Advertisement (Ad_ID, Campaign_ID, Title, Description, Format, Status, Date_Of_Creation) 
SELECT DISTINCT d.num, D.CODE, d.title, d.description, d.format, d.status, d.addate 
FROM DS4_ADS d;


INSERT INTO Audience (Interest, segment)
SELECT DISTINCT d.audience_interest, d.audience_segment 
FROM DS4_ADS D;

insert into targets (audience_id, campaign_id)   
select distinct au.audience_id, d.code
from ds4_ads d
join audience au on au.interest = d.audience_interest;


INSERT INTO Placement_Type (Type, Description)
SELECT DISTINCT d.placement_type, d.Type_Description 
FROM DS4_placement d;

INSERT INTO Placement (Placement_ID,Placement_type, Date_Placement, Cost_Placement, Exclusive_Placement) -- start time, end time removed
SELECT DISTINCT d.ID, pt.type, d.Placementdate, d.Cost, d.Exclusives -- d.ads NOT INCLUDED - RECHECK IN FUTURE
FROM DS4_placement d
join placement_type pt on pt.type = d.placement_type;


insert into disseminates(ad_id, placement_id)
select d.ads, d.id from ds4_placement d
join advertisement a on a.ad_id = d.ads;




INSERT INTO Categories (Name, Description)
SELECT DISTINCT 
c.Name,
c.Description
FROM (
SELECT 
	Category1 AS Name,
	Category1_Desc AS Description
FROM DS4_ADS
UNION ALL
SELECT 
	Category2 AS Name,
	Category2_Desc AS Description
FROM DS4_ADS
union all
select category3 as name, category3_desc as description from ds4_ads 
WHERE category is not null
) c;

insert into subcategory (category, name)
SELECT DISTINCT c.category, c.name
from (
select
REPLACE(
	SUBSTR(
		SUBSTR(d.category, INSTR(d.category, ',', 1, 3) + 2),
			1,
			LENGTH(SUBSTR(d.category, INSTR(d.category, ',', 1, 3) + 1)) - 3
		) ,'''','') AS name,
		d.category3 as category
	   from ds4_ads d      
WHERE LENGTH(d.category) - LENGTH(REPLACE(d.category, ',', '')) = 3) c;

insert into subcategory (category, name)
select distinct c.category,c.name
from (
select d.category3 as name, d.category2 as category from ds4_ads d where category3 is not null and category2 is not null
union all
select d.category2 as name, d.category1 as category from ds4_ads d where category1 is not null and category2 is not null) c;


INSERT INTO LOCATED2 (SHOP_ID, PLACEMENT_ID)
SELECT distinct S.ID_SHOP, D.ID
FROM DS4_PLACEMENT D
JOIN SHOP S ON S.NAME = D.BUILDING;

INSERT INTO LOCATED3 (ID_Program, PLACEMENT_ID)
SELECT DISTINCT P.ID_PROGRAM, D.ID
FROM DS4_PLACEMENT D
JOIN PROGRAMME P ON P.NAME = D.PROGRAMME;

INSERT INTO LOCATED4 (Post_ID, PLACEMENT_ID)
SELECT DISTINCT P.POST_ID, D.ID
FROM DS4_PLACEMENT D
JOIN POST P ON P.POST_ID = D.POST;


DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE Campaign CASCADE CONSTRAINTS;
DROP TABLE Audience CASCADE CONSTRAINTS;
DROP TABLE Targets CASCADE CONSTRAINTS;
DROP TABLE Categories CASCADE CONSTRAINTS;
DROP TABLE Placement CASCADE CONSTRAINTS;
DROP TABLE Placement_Type CASCADE CONSTRAINTS;
DROP TABLE Advertisement CASCADE CONSTRAINTS;
DROP TABLE Disseminates CASCADE CONSTRAINTS;
DROP TABLE ImagePost CASCADE CONSTRAINTS;
DROP TABLE Country CASCADE CONSTRAINTS;
DROP TABLE City CASCADE CONSTRAINTS;
DROP TABLE UserTable CASCADE CONSTRAINTS;
DROP TABLE Post CASCADE CONSTRAINTS;
DROP TABLE Tag CASCADE CONSTRAINTS;
DROP TABLE Media_Group CASCADE CONSTRAINTS;
DROP TABLE Image CASCADE CONSTRAINTS;
DROP TABLE Radio_Station CASCADE CONSTRAINTS;
DROP TABLE Programme CASCADE CONSTRAINTS;
DROP TABLE Radio_Programme CASCADE CONSTRAINTS;
DROP TABLE TV_Channel CASCADE CONSTRAINTS;
DROP TABLE TV_Programme CASCADE CONSTRAINTS;
DROP TABLE Participates CASCADE CONSTRAINTS;
DROP TABLE Reply CASCADE CONSTRAINTS;
DROP TABLE hashtagPost CASCADE CONSTRAINTS;

DROP TABLE haveCoach CASCADE CONSTRAINTS;
DROP TABLE havePlayer CASCADE CONSTRAINTS;
DROP TABLE compete CASCADE CONSTRAINTS;
DROP TABLE controls CASCADE CONSTRAINTS;
DROP TABLE plays CASCADE CONSTRAINTS;
DROP TABLE matchesT CASCADE CONSTRAINTS;
DROP TABLE club CASCADE CONSTRAINTS;
DROP TABLE referee CASCADE CONSTRAINTS;
DROP TABLE player CASCADE CONSTRAINTS;
DROP TABLE coach CASCADE CONSTRAINTS;
DROP TABLE coachTactics CASCADE CONSTRAINTS;
DROP TABLE competition CASCADE CONSTRAINTS;
DROP TABLE person CASCADE CONSTRAINTS;
DROP TABLE Inventory CASCADE CONSTRAINTS;
DROP TABLE Product CASCADE CONSTRAINTS;
DROP TABLE Sales CASCADE CONSTRAINTS;
DROP TABLE Shop CASCADE CONSTRAINTS;
DROP TABLE Shopkeeper CASCADE CONSTRAINTS;
DROP TABLE Activity CASCADE CONSTRAINTS;
DROP TABLE ProductType CASCADE CONSTRAINTS; 
DROP TABLE productCampaign CASCADE CONSTRAINTS;
DROP TABLE subCategory CASCADE CONSTRAINTS;
DROP TABLE LOCATED2 CASCADE CONSTRAINTS;
DROP TABLE LOCATED3 CASCADE CONSTRAINTS;
DROP TABLE LOCATED4 CASCADE CONSTRAINTS;
DROP TABLE SHOPKEEPERSHIFT CASCADE CONSTRAINTS;

CREATE TABLE Country (
    Country_Name VARCHAR2(255) PRIMARY KEY
);
CREATE TABLE City (
    City_ID NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    Country_Name VARCHAR2(255),
    City_Name VARCHAR2(255),
    PRIMARY KEY(City_ID),
    FOREIGN KEY (Country_Name) REFERENCES Country(Country_Name)
);

CREATE TABLE UserTable (
    name VARCHAR2(255) PRIMARY KEY,
    city_id int,
    verified INT,
    creation_date DATE,
    FOREIGN key (city_id) references city(city_id)
);
CREATE TABLE person (
    PersonID INT GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    name_person VARCHAR2(255),
    surname VARCHAR2(255),
    date_of_birth DATE,
    gender VARCHAR2(255),
    usernameLSSL VARCHAR2(255),
    PRIMARY KEY(PersonID),
    FOREIGN KEY(usernameLSSL) REFERENCES UserTable(name)
);


CREATE TABLE Tag (
    Name VARCHAR2(255) PRIMARY KEY,
    Description VARCHAR2(1023),
    Trend_Status VARCHAR2(255)
);

CREATE TABLE Image (
    Path VARCHAR2(255) ,
    Title VARCHAR2(255),
    Mime VARCHAR2(255),
    PRIMARY KEY(Path)
);

CREATE TABLE Post (
    Post_ID INT PRIMARY KEY,
    FK_User VARCHAR2(255),
    PostText VARCHAR2(1023),
    Creation_Date DATE,
    Likes INT,
    Reposts INT,
    FOREIGN KEY (FK_User) REFERENCES UserTable(name)
);
CREATE TABLE Reply(
    Post_ID INT,
    Reply_To INT, 
    PRIMARY KEY (Post_ID, Reply_To),
    FOREIGN KEY (Post_ID) REFERENCES Post(Post_ID)
);

CREATE TABLE HashtagPost(
    Post_ID INT,
    Hashtag VARCHAR2(255),
    PRIMARY KEY (Post_ID, Hashtag),
    FOREIGN KEY (Post_ID) REFERENCES Post(Post_ID),
    FOREIGN KEY (Hashtag) REFERENCES Tag(Name)
);

CREATE TABLE ImagePost(
    Image_Path VARCHAR2(255),
    Post_ID INT,
    Title VARCHAR2(255),
    PRIMARY KEY(Image_Path, Post_ID),
    FOREIGN KEY (Image_Path) REFERENCES Image(Path),
    FOREIGN KEY (Post_ID) REFERENCES Post(Post_ID)
);

CREATE TABLE Media_Group (
    ID_Group NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    Name VARCHAR2(255),
    Description VARCHAR2(1023),
    HQ_Name VARCHAR2(255),
    FK_HQ_City_ID INT,
    PRIMARY KEY (ID_Group),
    FOREIGN KEY (FK_HQ_City_ID) REFERENCES City(City_ID)
);

CREATE TABLE Radio_Station (
    RS_ID NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    FK_ID_Group INT,
    Name VARCHAR2(255),
    Description VARCHAR2(1023),
    Broadcast_Frequency VARCHAR2(26),
    PRIMARY KEY (RS_ID),
    FOREIGN KEY (FK_ID_Group) REFERENCES Media_Group(ID_Group)
);

CREATE TABLE Programme (
    ID_Program INT GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    Name VARCHAR2(255),
    LSSL VARCHAR2(255),
    SCHEDULE VARCHAR2(20),
    Description VARCHAR2(1023),
    PRIMARY KEY(ID_Program)
);

CREATE TABLE Radio_Programme (
    ID_Radio_Program INT,
    Ass_Podcast INT,
    FK_RADIO_STATION NUMBER,
    PRIMARY KEY (ID_Radio_Program, FK_RADIO_STATION),
    FOREIGN KEY (ID_Radio_Program) REFERENCES Programme(ID_Program),
    FOREIGN KEY (FK_RADIO_STATION) REFERENCES Radio_Station(RS_ID)
);
CREATE TABLE TV_Channel (
    Channel_ID INT GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    FK_ID_Group INT,
    Name VARCHAR2(255),
    VideoQuality VARCHAR(50),
    PRIMARY KEY (Channel_ID),
    FOREIGN KEY (FK_ID_Group) REFERENCES Media_Group(ID_Group)
);

CREATE TABLE TV_Programme (
    ID_TV_Program INT,
    FK_Channel_ID INT,
    Prod_Company VARCHAR2(255),
    PRIMARY KEY (ID_TV_Program),
    FOREIGN KEY (FK_Channel_ID) REFERENCES TV_Channel(Channel_ID),
    FOREIGN KEY (ID_TV_Program) REFERENCES Programme(ID_Program)
);
CREATE TABLE Participates (
    ID_Person INT ,
    ID_Program INT,
    Specialization VARCHAR2(255),
    PRIMARY KEY (ID_Person, ID_Program, Specialization),
    FOREIGN KEY (ID_Person) REFERENCES person(PersonID),
    FOREIGN KEY (ID_Program) REFERENCES Programme(ID_Program)
);
CREATE TABLE Customer (
    Customer_ID INT GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    Name VARCHAR2(255),
    Basic_Address NUMBER,
    Client_Budget NUMBER,
    city_id int,
    PRIMARY KEY (Customer_ID),
    foreign key (city_id) references city(city_id)
);

CREATE TABLE Campaign (
    Campaign_ID VARCHAR2(255),
    Customer_ID INT,
    Name VARCHAR2(255),
    Objective VARCHAR2(255),
    Start_date DATE,
    End_date DATE,
    Budget INT,
    PRIMARY KEY (Campaign_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);
create table productCampaign(
    ID_Campaign VARCHAR2(255),
    ID_Product NUMBER,
    PRIMARY KEY(ID_Campaign, ID_Product)
);


CREATE TABLE Advertisement (
    Ad_ID NUMBER,
    Campaign_ID VARCHAR2(255),
    Title VARCHAR2(255),
    Description VARCHAR2(255),
    Format VARCHAR2(50),
    Status VARCHAR2(50),
    Date_Of_Creation DATE,
    PRIMARY KEY (Ad_ID),
    FOREIGN KEY (Campaign_ID) REFERENCES Campaign(Campaign_ID)
);

CREATE TABLE Audience (
    Audience_ID INT GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    Interest VARCHAR2(255),
    SEGMENT VARCHAR2(255),
    PRIMARY KEY (Audience_ID)
);

CREATE TABLE Targets (
    Audience_ID INT,
    Campaign_ID VARCHAR2(255),
    PRIMARY KEY (Audience_ID, Campaign_ID),
    FOREIGN KEY (Audience_ID) REFERENCES Audience(Audience_ID),
    FOREIGN KEY (Campaign_ID) REFERENCES Campaign(Campaign_ID)
);

CREATE TABLE Categories (
    Category_ID INT GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    Name VARCHAR2(255),
    Description VARCHAR2(255),
    PRIMARY KEY (Category_ID)
);
create table subcategory(
    name varchar(255) ,
    category varchar2(255),
    PRIMARY KEY (name, category)
);

CREATE TABLE Placement (
    Placement_ID NUMBER,
    placement_type varchar2(255),
    ads NUMBER,
    Date_placement DATE,
    Start_time TIMESTAMP, 
    End_time TIMESTAMP,  
    Cost_Placement NUMBER,
    Exclusive_Placement NUMBER, 
    PRIMARY KEY (Placement_ID),
    FOREIGN KEY (ADS) REFERENCES ADVERTISEMENT(AD_ID)
); 
    
create table disseminates(
    ad_id int,
    placement_id int,
    primary key(ad_id, placement_id),
    foreign key (ad_id) references advertisement(ad_id) ,
    foreign key (placement_id) references placement(placement_id)
);



CREATE TABLE Located3 (
    ID_Program INT,
    Placement_ID INT,
    PRIMARY KEY(ID_Program, Placement_ID),
    FOREIGN KEY (ID_Program) REFERENCES PROGRAMME(ID_Program)
);
CREATE TABLE Located4 (
    Post_ID INT,
    Placement_ID INT,
    PRIMARY KEY(Post_ID, Placement_ID),
    FOREIGN KEY (POST_ID) REFERENCES POST(POST_ID)
);


CREATE TABLE Placement_Type (
    Type VARCHAR2(255) PRIMARY KEY,
    Description VARCHAR2(255)
    );



    
    CREATE TABLE coach(
        CoachID INT PRIMARY KEY,
        TrainingStyle VARCHAR2(255),
        Tactics VARCHAR2(255),
        FOREIGN KEY (CoachID) REFERENCES person(PersonID)
    );
    
    CREATE TABLE COACHTACTICS(
        COACH_ID INT,
        tactics VARCHAR2(255),
        primary key(coach_id, tactics),
        foreign key (coach_id) references coach(coachid)
    );
    
    CREATE TABLE player (
        PlayerID INT PRIMARY KEY,
        CoachID INT,
        Height INT,
        Weight INT,
        Footed VARCHAR2(255),
        FOREIGN KEY (CoachID) REFERENCES coach(CoachID),
        FOREIGN KEY (PlayerID) REFERENCES person(PersonID)
    );
    
    CREATE TABLE referee (
        RefereeID INT,
        certification VARCHAR2(255),
        PRIMARY KEY(RefereeID),
        FOREIGN KEY (RefereeID) REFERENCES person(PersonID)
    );
    
    CREATE TABLE club (
        ClubID VARCHAR2(255),
        City_ID INT,
        PRIMARY KEY(ClubID),
        FOREIGN KEY (City_ID) REFERENCES city(City_ID)
    );
    
    CREATE TABLE matchesT (
        MatchID VARCHAR2(255),
        Match_date DATE,
        goals_Local INT,
        goals_Visitor INT,
        Local_club VARCHAR2(255),
        Visitor_club VARCHAR2(255),
        Local_poss INT,
        Visitor_poss INT,
        Local_manager INT,
        Visitor_manager INT,
        Venue VARCHAR2(255),
        Attendance INT,
        Match_city INT,
        season varchar2(255),
        competition_id varchar2(255),
        PRIMARY KEY(MatchID),
        FOREIGN KEY (local_club) REFERENCES club(ClubID),
        FOREIGN KEY (visitor_club) REFERENCES club(ClubID)
    );
    
    CREATE TABLE plays (
        PlayerID INT,
        MatchID VARCHAR2(255),
        Club VARCHAR2(255),
        Goals INT,
        Position VARCHAR2(255),
        Shots INT,
        Shots_on_target INT,
        Assists INT,
        YellowCards INT,
        RedCards INT,
        PRIMARY KEY(PlayerID,MatchID),
        FOREIGN KEY (PlayerID) REFERENCES player(PlayerID),
        FOREIGN KEY (MatchID) REFERENCES matchesT(MatchID)
    );
    
    
    CREATE TABLE controls (
        referee_id INT,
        match_id VARCHAR2(255),
        roleRef VARCHAR2(255),
        PRIMARY KEY (referee_id, match_id, ROLEREF),
        FOREIGN KEY (referee_id) REFERENCES referee(RefereeID),
        FOREIGN KEY (match_id) REFERENCES matchesT(MatchID)
    );
    
    
    CREATE TABLE HavePlayer (
        HavePlayerID NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
        player_id INT,
        club_id VARCHAR2(255),
        start_date DATE,
        end_date DATE,
        PRIMARY KEY (HavePlayerID),
        FOREIGN KEY (player_id) REFERENCES PLAYER(PLAYERID),
        FOREIGN KEY (club_id) REFERENCES CLUB(ClubID)
    );
    
    
    CREATE TABLE competition (
        CompetitionID VARCHAR2(255),
        gender VARCHAR2(255),
        PRIMARY KEY(CompetitionID)
    );
    
    CREATE TABLE compete (
        Season VARCHAR2(255),
        CompetitionID VARCHAR2(255),
        ClubID VARCHAR2(255),
        Position int,
            PRIMARY KEY(Season, CompetitionID, ClubID),
        FOREIGN KEY (CompetitionID) REFERENCES competition(CompetitionID),
        FOREIGN KEY (ClubID) REFERENCES club(ClubID)
    );
    
    CREATE TABLE HaveCoach (
        HaveCoachID NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
        club_id VARCHAR2(255),
        coach_id INT,
        start_date DATE,
        end_date DATE,
        PRIMARY KEY (HaveCoachID),
        FOREIGN KEY (club_id) REFERENCES CLUB(ClubID),
        FOREIGN KEY (coach_id) REFERENCES COACH(CoachID)
    );
    
    
    -- Independent tables
CREATE TABLE ProductType (
    ID_Type NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    pt_name VARCHAR2(26),
    pt_description VARCHAR2(128),
    PRIMARY KEY (ID_Type)
);

CREATE TABLE Activity (
    ID_Activity NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    act_name VARCHAR2(128),
    act_description VARCHAR2(128),
    PRIMARY KEY (ID_Activity)
);


-- Shop table must exist before it can be referenced by Shopkeeper
CREATE TABLE Shop (
    ID_Shop NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    name VARCHAR2(128),
    description VARCHAR2(256),
    City_ID INT,
    PRIMARY KEY (ID_Shop),
    FOREIGN KEY (City_ID) REFERENCES City(City_ID)
);
-- Shopkeeper must exist before it can be referenced by Shop
CREATE TABLE Shopkeeper (
    ID_Shopkeeper INT,
    description VARCHAR2(255),
    off_days int,
    PRIMARY KEY (ID_Shopkeeper),
    FOREIGN KEY (ID_Shopkeeper) REFERENCES person(PersonID)
);
CREATE TABLE shopkeeperShift(
    ID_SHOPKEEPER INT,
    SHIFT VARCHAR2(255),
    ROLE VARCHAR2(255),
    ID_SHOP INT,
    PRIMARY KEY (ID_SHOPKEEPER, ID_SHOP, ROLE),
    FOREIGN KEY (ID_Shop) REFERENCES Shop(ID_Shop),
    FOREIGN KEY (ID_SHOPKEEPER) REFERENCES SHOPKEEPER(ID_SHOPKEEPER)
);

-- Product depends on ProductType, Activity, Club
CREATE TABLE Product (
    ID_Product NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
    p_name VARCHAR2(256),
    officiality VARCHAR2(100),
    p_size VARCHAR2(50),
    special_feature VARCHAR2(255),
    p_use VARCHAR2(255),
    type_closure VARCHAR2(255),
    p_property VARCHAR2(255),
    cloth_material VARCHAR2(50),
    relevant_characteristic VARCHAR2(255),
    ID_Activity number,
    ClubID VARCHAR2(255),
    ID_Type number,
    PRIMARY KEY (ID_Product),
    FOREIGN KEY (ID_Activity) REFERENCES Activity(ID_Activity),
    FOREIGN KEY (ClubID) REFERENCES Club(ClubID),
    FOREIGN KEY (ID_Type) REFERENCES ProductType(ID_Type)
);

-- Product_detail depends on Product and Sales
CREATE TABLE sales (
    ID_Product INT,
    discount varchar2(50),
    p_units NUMBER(38), --new variable
    p_cost NUMBER(38,2),
    p_purchaseDate VARCHAR2(50),
    credit_card_number VARCHAR2(26),
    credit_card_expiry_date VARCHAR2(26),
    credit_card_provider VARCHAR2(128),
    ID_shop int,
    PRIMARY KEY (p_purchaseDate, ID_Product, ID_shop),
    FOREIGN KEY (ID_Product) REFERENCES Product(ID_Product)
);

-- Inventory depends on Product and Shop
CREATE TABLE Inventory (
    ID_Product INTEGER,
    ID_Shop INTEGER,
    no_products INTEGER,
    PRIMARY KEY (ID_Product, ID_Shop),
    FOREIGN KEY (ID_Product) REFERENCES Product(ID_Product),
    FOREIGN KEY (ID_Shop) REFERENCES Shop(ID_Shop)
);
CREATE TABLE Located2 (
    SHOP_ID INT,
    Placement_ID INT,
    PRIMARY KEY(Placement_ID, SHOP_ID),
    FOREIGN KEY (SHOP_ID) REFERENCES SHOP(ID_SHOP)
);



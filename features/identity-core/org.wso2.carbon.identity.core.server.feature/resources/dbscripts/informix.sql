CREATE TABLE IDN_BASE_TABLE (
            PRODUCT_NAME LVARCHAR(20),
            PRIMARY KEY (PRODUCT_NAME)
);

INSERT INTO IDN_BASE_TABLE values ('WSO2 Identity Server');

CREATE TABLE IDN_OAUTH_CONSUMER_APPS (
            CONSUMER_KEY LVARCHAR(255),
            CONSUMER_SECRET LVARCHAR(512),
            USERNAME LVARCHAR(255),
            TENANT_ID INTEGER DEFAULT 0,
            APP_NAME LVARCHAR(255),
            OAUTH_VERSION LVARCHAR(128),
            CALLBACK_URL LVARCHAR(1024),
            GRANT_TYPES LVARCHAR (1024),
            PRIMARY KEY (CONSUMER_KEY)
);

CREATE TABLE IDN_OAUTH1A_REQUEST_TOKEN (
            REQUEST_TOKEN LVARCHAR(255),
            REQUEST_TOKEN_SECRET LVARCHAR(512),
            CONSUMER_KEY LVARCHAR(255),
            CALLBACK_URL LVARCHAR(1024),
            SCOPE LVARCHAR(2048),
            AUTHORIZED LVARCHAR(128),
            OAUTH_VERIFIER LVARCHAR(512),
            AUTHZ_USER LVARCHAR(512),
            PRIMARY KEY (REQUEST_TOKEN),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE
);


CREATE TABLE IDN_OAUTH1A_ACCESS_TOKEN (
            ACCESS_TOKEN LVARCHAR(255),
            ACCESS_TOKEN_SECRET LVARCHAR(512),
            CONSUMER_KEY LVARCHAR(255),
            SCOPE LVARCHAR(2048),
            AUTHZ_USER LVARCHAR(512),
            PRIMARY KEY (ACCESS_TOKEN),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE
);

CREATE TABLE IDN_OAUTH2_AUTHORIZATION_CODE (
            AUTHORIZATION_CODE LVARCHAR(255),
            CONSUMER_KEY LVARCHAR(255),
	        CALLBACK_URL LVARCHAR(1024),
            SCOPE LVARCHAR(2048),
            AUTHZ_USER LVARCHAR(512),
	        TIME_CREATED DATETIME YEAR TO SECOND,
	        VALIDITY_PERIOD BIGINT,
            PRIMARY KEY (AUTHORIZATION_CODE),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE
);

CREATE TABLE IDN_OAUTH2_ACCESS_TOKEN (
			ACCESS_TOKEN LVARCHAR(255),
			REFRESH_TOKEN LVARCHAR(255),
			CONSUMER_KEY LVARCHAR(255),
			AUTHZ_USER LVARCHAR(100),
			USER_TYPE LVARCHAR (25),
			TIME_CREATED DATETIME YEAR TO SECOND,
			REFRESH_TOKEN_TIME_CREATED DATETIME YEAR TO SECOND,
			VALIDITY_PERIOD BIGINT,
			REFRESH_TOKEN_VALIDITY_PERIOD BIGINT,
			TOKEN_SCOPE LVARCHAR(2048),
			TOKEN_STATE LVARCHAR(25) DEFAULT 'ACTIVE',
			TOKEN_STATE_ID LVARCHAR (255) DEFAULT 'NONE',
			PRIMARY KEY (ACCESS_TOKEN),
            FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE,
            UNIQUE (CONSUMER_KEY,AUTHZ_USER,USER_TYPE,TOKEN_SCOPE,TOKEN_STATE,TOKEN_STATE_ID) CONSTRAINT CON_APP_KEY
);

CREATE INDEX IDX_AT_CK_AU ON IDN_OAUTH2_ACCESS_TOKEN(CONSUMER_KEY, AUTHZ_USER, TOKEN_STATE, USER_TYPE);

CREATE TABLE IDN_OAUTH2_SCOPE (
            SCOPE_ID SERIAL UNIQUE,
            SCOPE_KEY LVARCHAR(100) NOT NULL,
            NAME LVARCHAR(255) NULL,
            DESCRIPTION LVARCHAR(512) NULL,
            TENANT_ID INTEGER NOT NULL,
            ROLES LVARCHAR (500) NULL,
            PRIMARY KEY (SCOPE_ID)
);

CREATE TABLE IDN_OAUTH2_RESOURCE_SCOPE (
            RESOURCE_PATH LVARCHAR(255) NOT NULL,
            SCOPE_ID INTEGER NOT NULL,
            PRIMARY KEY (RESOURCE_PATH),
            FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE (SCOPE_ID) ON DELETE CASCADE
);

CREATE TABLE IDN_SCIM_GROUP (
			ID SERIAL UNIQUE,
			TENANT_ID INTEGER NOT NULL,
			ROLE_NAME LVARCHAR(255) NOT NULL,
            ATTR_NAME LVARCHAR(1024) NOT NULL,
			ATTR_VALUE LVARCHAR(1024)
);

CREATE TABLE IDN_SCIM_PROVIDER (
            CONSUMER_ID LVARCHAR(255) NOT NULL,
            PROVIDER_ID LVARCHAR(255) NOT NULL,
            USER_NAME LVARCHAR(255) NOT NULL,
            USER_PASSWORD LVARCHAR(255) NOT NULL,
            USER_URL LVARCHAR(1024) NOT NULL,
			GROUP_URL LVARCHAR(1024),
			BULK_URL LVARCHAR(1024),
            PRIMARY KEY (CONSUMER_ID,PROVIDER_ID)
);

CREATE TABLE IDN_OPENID_REMEMBER_ME (
            USER_NAME LVARCHAR(255) NOT NULL,
            TENANT_ID INTEGER DEFAULT 0,
            COOKIE_VALUE LVARCHAR(1024),
            CREATED_TIME DATETIME YEAR TO SECOND,
            PRIMARY KEY (USER_NAME, TENANT_ID)
);

CREATE TABLE IDN_OPENID_USER_RPS (
			USER_NAME LVARCHAR(255) NOT NULL,
			TENANT_ID INTEGER DEFAULT 0,
			RP_URL LVARCHAR(255) NOT NULL,
			TRUSTED_ALWAYS LVARCHAR(128) DEFAULT 'f',
			LAST_VISIT DATE NOT NULL,
			VISIT_COUNT INTEGER DEFAULT 0,
			DEFAULT_PROFILE_NAME LVARCHAR(255) DEFAULT 'DEFAULT',
			PRIMARY KEY (USER_NAME, TENANT_ID, RP_URL)
);

CREATE TABLE IDN_OPENID_ASSOCIATIONS (
			HANDLE LVARCHAR(255) NOT NULL,
			ASSOC_TYPE LVARCHAR(255) NOT NULL,
			EXPIRE_IN DATETIME YEAR TO SECOND NOT NULL,
			MAC_KEY LVARCHAR(255) NOT NULL,
			ASSOC_STORE LVARCHAR(128) DEFAULT 'SHARED',
			PRIMARY KEY (HANDLE)
);

CREATE TABLE IDN_STS_STORE (
             ID SERIAL UNIQUE,
             TOKEN_ID LVARCHAR(255) NOT NULL,
             TOKEN_CONTENT BLOB(1024) NOT NULL,
             CREATE_DATE DATETIME YEAR TO SECOND NOT NULL,
             EXPIRE_DATE DATETIME YEAR TO SECOND NOT NULL,
             STATE INTEGER DEFAULT 0
);

CREATE TABLE IDN_IDENTITY_USER_DATA (
             TENANT_ID INTEGER DEFAULT -1234,
             USER_NAME LVARCHAR(255) NOT NULL,
             DATA_KEY LVARCHAR(255) NOT NULL,
             DATA_VALUE LVARCHAR(255),
             PRIMARY KEY (TENANT_ID, USERR_NAME, DATA_KEY)
);

CREATE TABLE IDN_IDENTITY_META_DATA (
            USER_NAME LVARCHAR(255) NOT NULL,
            TENANT_ID INTEGER DEFAULT -1234,
            METADATA_TYPE LVARCHAR(255) NOT NULL,
            METADATA LVARCHAR(255) NOT NULL,
            VALID LVARCHAR(255) NOT NULL,
            PRIMARY KEY (TENANT_ID, USER_NAME, METADATA_TYPE,METADATA)
);

CREATE TABLE IF NOT EXISTS IDN_THRIFT_SESSION (
            SESSION_ID LVARCHAR(255) NOT NULL,
            USER_NAME LVARCHAR(255) NOT NULL,
            CREATED_TIME LVARCHAR(255) NOT NULL,
            LAST_MODIFIED_TIME LVARCHAR(255) NOT NULL,
            PRIMARY KEY (SESSION_ID)
);

CREATE TABLE IDN_AUTH_SESSION_STORE (
            SESSION_ID LVARCHAR (100) DEFAULT NULL,
            SESSION_TYPE LVARCHAR(100) DEFAULT NULL,
            SESSION_OBJECT BLOB,
            TIME_CREATED TIMESTAMP,
            PRIMARY KEY (SESSION_ID, SESSION_TYPE)
);

CREATE TABLE SP_APP (
            ID INTEGER SERIAL UNIQUE,
            TENANT_ID INTEGER NOT NULL,
	    	APP_NAME LVARCHAR (255) NOT NULL ,
	    	USER_STORE LVARCHAR (255) NOT NULL,
            USERNAME LVARCHAR (255) NOT NULL ,
            DESCRIPTION LVARCHAR (1024),
	    	ROLE_CLAIM LVARCHAR (512),
            AUTH_TYPE LVARCHAR (255) NOT NULL,
	    	PROVISIONING_USERSTORE_DOMAIN LVARCHAR (512),
	    	IS_LOCAL_CLAIM_DIALECT CHAR(1) DEFAULT '1',
	    	IS_SEND_LOCAL_SUBJECT_ID CHAR(1) DEFAULT '0',
	    	IS_SEND_AUTH_LIST_OF_IDPS CHAR(1) DEFAULT '0',
	    	SUBJECT_CLAIM_URI VARCHAR (512),
	    	IS_SAAS_APP CHAR(1) DEFAULT '0',
            PRIMARY KEY (ID));

ALTER TABLE SP_APP ADD CONSTRAINT APPLICATION_NAME_CONSTRAINT UNIQUE(APP_NAME, TENANT_ID);

CREATE TABLE SP_INBOUND_AUTH (
            ID INTEGER SERIAL UNIQUE,
	     	TENANT_ID INTEGER NOT NULL,
	     	INBOUND_AUTH_KEY LVARCHAR (255) NOT NULL,
            INBOUND_AUTH_TYPE LVARCHAR (255) NOT NULL,
            PROP_NAME LVARCHAR (255),
            PROP_VALUE LVARCHAR (1024) ,
	     	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID));

ALTER TABLE SP_INBOUND_AUTH ADD CONSTRAINT APPLICATION_ID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE SP_AUTH_STEP (
            ID INTEGER SERIAL UNIQUE,
            TENANT_ID INTEGER NOT NULL,
	     	STEP_ORDER INTEGER DEFAULT 1,
            APP_ID INTEGER NOT NULL,
            IS_SUBJECT_STEP CHAR(1) DEFAULT '0',
            IS_ATTRIBUTE_STEP CHAR(1) DEFAULT '0',
            PRIMARY KEY (ID));

ALTER TABLE SP_AUTH_STEP ADD CONSTRAINT APPLICATION_ID_CONSTRAINT_STEP FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE SP_FEDERATED_IDP (
            ID INTEGER NOT NULL,
            TENANT_ID INTEGER NOT NULL,
            AUTHENTICATOR_ID INTEGER NOT NULL,
            PRIMARY KEY (ID, AUTHENTICATOR_ID));

ALTER TABLE SP_FEDERATED_IDP ADD CONSTRAINT STEP_ID_CONSTRAINT FOREIGN KEY (ID) REFERENCES SP_AUTH_STEP (ID) ON DELETE CASCADE;

CREATE TABLE SP_CLAIM_MAPPING (
	    	ID INTEGER SERIAL UNIQUE,
	    	TENANT_ID INTEGER NOT NULL,
	    	IDP_CLAIM LVARCHAR (512) NOT NULL ,
            SP_CLAIM LVARCHAR (512) NOT NULL ,
	   		APP_ID INTEGER NOT NULL,
	    	IS_REQUESTED LVARCHAR(128) DEFAULT '0',
			DEFAULT_VALUE LVARCHAR(255),
            PRIMARY KEY (ID));

ALTER TABLE SP_CLAIM_MAPPING ADD CONSTRAINT CLAIMID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE SP_ROLE_MAPPING (
	    	ID INTEGER SERIAL UNIQUE,
	    	TENANT_ID INTEGER NOT NULL,
	    	IDP_ROLE LVARCHAR (255) NOT NULL ,
            SP_ROLE LVARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID));

ALTER TABLE SP_ROLE_MAPPING ADD CONSTRAINT ROLEID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE SP_REQ_PATH_AUTHENTICATOR (
	    	ID INTEGER SERIAL UNIQUE,
	    	TENANT_ID INTEGER NOT NULL,
	    	AUTHENTICATOR_NAME LVARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
            PRIMARY KEY (ID));

ALTER TABLE SP_REQ_PATH_AUTHENTICATOR ADD CONSTRAINT REQ_AUTH_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE SP_PROVISIONING_CONNECTOR (
	    	ID INTEGER SERIAL UNIQUE,
	    	TENANT_ID INTEGER NOT NULL,
            IDP_NAME LVARCHAR (255) NOT NULL ,
	    	CONNECTOR_NAME LVARCHAR (255) NOT NULL ,
	    	APP_ID INTEGER NOT NULL,
	    	IS_JIT_ENABLED CHAR(1) NOT NULL DEFAULT '0',
		BLOCKING CHAR(1) NOT NULL DEFAULT '0',
            PRIMARY KEY (ID));

ALTER TABLE SP_PROVISIONING_CONNECTOR ADD CONSTRAINT PRO_CONNECTOR_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE IDP (
			ID INTEGER SERIAL UNIQUE,
			TENANT_ID INTEGER,
			NAME LVARCHAR(254) NOT NULL,
			IS_ENABLED CHAR(1) NOT NULL DEFAULT '1',
			IS_PRIMARY CHAR(1) NOT NULL DEFAULT '0',
			HOME_REALM_ID LVARCHAR(254),
			IMAGE BLOB,
			CERTIFICATE BLOB,
			ALIAS LVARCHAR(254),
			INBOUND_PROV_ENABLED CHAR (1) NOT NULL DEFAULT '0',
			INBOUND_PROV_USER_STORE_ID LVARCHAR(254),
 			USER_CLAIM_URI LVARCHAR(254),
 			ROLE_CLAIM_URI LVARCHAR(254),
			DESCRIPTION VARCHAR (1024),
 			DEFAULT_AUTHENTICATOR_NAME LVARCHAR(254),
 			DEFAULT_PRO_CONNECTOR_NAME LVARCHAR(254),
			PROVISIONING_ROLE VARCHAR(128),
			IS_FEDERATION_HUB CHAR(1) NOT NULL DEFAULT '0',
			IS_LOCAL_CLAIM_DIALECT CHAR(1) NOT NULL DEFAULT '0',
			PRIMARY KEY (ID),
	                DISPLAY_NAME VARCHAR(254),
			UNIQUE (TENANT_ID, NAME));

INSERT INTO IDP (TENANT_ID, NAME, HOME_REALM_ID) VALUES (-1234, 'LOCAL', 'localhost');

CREATE TABLE IDP_ROLE (
			ID INTEGER SERIAL UNIQUE,
			IDP_ID INTEGER,
			TENANT_ID INTEGER,
			ROLE LVARCHAR(254),
			PRIMARY KEY (ID),
			UNIQUE (IDP_ID, ROLE),
			FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

CREATE TABLE IDP_ROLE_MAPPING (
			ID INTEGER SERIAL UNIQUE,
			IDP_ROLE_ID INTEGER,
			TENANT_ID INTEGER,
			USER_STORE_ID LVARCHAR (253),
			LOCAL_ROLE LVARCHAR(253),
			PRIMARY KEY (ID),
			UNIQUE (IDP_ROLE_ID, TENANT_ID, USER_STORE_ID, LOCAL_ROLE),
			FOREIGN KEY (IDP_ROLE_ID) REFERENCES IDP_ROLE(ID) ON DELETE CASCADE);

CREATE TABLE IDP_CLAIM (
			ID INTEGER SERIAL UNIQUE,
			IDP_ID INTEGER,
			TENANT_ID INTEGER,
			CLAIM LVARCHAR(254),
			PRIMARY KEY (ID),
			UNIQUE (IDP_ID, CLAIM),
			FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

CREATE TABLE IDP_CLAIM_MAPPING (
			ID INTEGER SERIAL UNIQUE,
			IDP_CLAIM_ID INTEGER,
			TENANT_ID INTEGER,
			LOCAL_CLAIM LVARCHAR(253),
			DEFAULT_VALUE VARCHAR(255),
	    	IS_REQUESTED LVARCHAR(128) DEFAULT '0',
			PRIMARY KEY (ID),
			UNIQUE (IDP_CLAIM_ID, TENANT_ID, LOCAL_CLAIM),
			FOREIGN KEY (IDP_CLAIM_ID) REFERENCES IDP_CLAIM(ID) ON DELETE CASCADE);

CREATE TABLE IDP_AUTHENTICATOR (
            ID INTEGER SERIAL UNIQUE,
            TENANT_ID INTEGER,
            IDP_ID INTEGER,
            NAME LVARCHAR(255) NOT NULL,
            IS_ENABLED CHAR (1) DEFAULT '1',
            DISPLAY_NAME VARCHAR(255),
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, NAME),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

INSERT INTO IDP_AUTHENTICATOR (TENANT_ID, IDP_ID, NAME) VALUES (-1234, 1, 'samlsso');

CREATE TABLE IDP_AUTHENTICATOR_PROPERTY (
            ID INTEGER SERIAL UNIQUE,
            TENANT_ID INTEGER,
            AUTHENTICATOR_ID INTEGER,
            PROPERTY_KEY LVARCHAR(255) NOT NULL,
            PROPERTY_VALUE LVARCHAR(2047),
            IS_SECRET CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY),
            FOREIGN KEY (AUTHENTICATOR_ID) REFERENCES IDP_AUTHENTICATOR(ID) ON DELETE CASCADE);

INSERT INTO  IDP_AUTHENTICATOR_PROPERTY (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY,PROPERTY_VALUE, IS_SECRET ) VALUES (-1234, 1 , 'IdPEntityId', 'localhost', '0');

CREATE TABLE IDP_PROVISIONING_CONFIG (
            ID INTEGER SERIAL UNIQUE,
            TENANT_ID INTEGER,
            IDP_ID INTEGER,
            PROVISIONING_CONNECTOR_TYPE LVARCHAR(255) NOT NULL,
			IS_ENABLED CHAR (1) DEFAULT '0',
			IS_BLOCKING CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, PROVISIONING_CONNECTOR_TYPE),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

CREATE TABLE IDP_PROV_CONFIG_PROPERTY (
            ID INTEGER SERIAL UNIQUE,
            TENANT_ID INTEGER,
            PROVISIONING_CONFIG_ID INTEGER,
            PROPERTY_KEY LVARCHAR(255) NOT NULL,
            PROPERTY_VALUE LVARCHAR(2048),
            PROPERTY_BLOB_VALUE BLOB,
            PROPERTY_TYPE CHAR(32) NOT NULL,
            IS_SECRET CHAR (1) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, PROVISIONING_CONFIG_ID, PROPERTY_KEY),
            FOREIGN KEY (PROVISIONING_CONFIG_ID) REFERENCES IDP_PROVISIONING_CONFIG(ID) ON DELETE CASCADE);

CREATE TABLE IDP_PROVISIONING_ENTITY (
            ID INTEGER SERIAL UNIQUE,
            PROVISIONING_CONFIG_ID INTEGER,
            ENTITY_TYPE LVARCHAR(255) NOT NULL,
            ENTITY_LOCAL_USERSTORE LVARCHAR(255) NOT NULL,
            ENTITY_NAME LVARCHAR(255) NOT NULL,
            ENTITY_VALUE LVARCHAR(255),
            TENANT_ID INTEGER,
            PRIMARY KEY (ID),
            UNIQUE (ENTITY_TYPE, TENANT_ID, ENTITY_LOCAL_USERSTORE, ENTITY_NAME, PROVISIONING_CONFIG_ID),
            UNIQUE (PROVISIONING_CONFIG_ID, ENTITY_TYPE, ENTITY_VALUE),
            FOREIGN KEY (PROVISIONING_CONFIG_ID) REFERENCES IDP_PROVISIONING_CONFIG(ID) ON DELETE CASCADE);

CREATE TABLE IDP_LOCAL_CLAIM (
            ID INTEGER SERIAL UNIQUE,
            TENANT_ID INTEGER,
            IDP_ID INTEGER,
            CLAIM_URI LVARCHAR(255) NOT NULL,
            DEFAULT_VALUE LVARCHAR(255),
       	    IS_REQUESTED LVARCHAR(128) DEFAULT '0',
            PRIMARY KEY (ID),
            UNIQUE (TENANT_ID, IDP_ID, CLAIM_URI),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

CREATE TABLE IF NOT EXISTS IDN_ASSOCIATED_ID (
            ID INTEGER SERIAL UNIQUE,
	    IDP_USER_ID VARCHAR(255) NOT NULL,
            TENANT_ID INTEGER DEFAULT -1234,
	    IDP_ID INTEGER NOT NULL,
            DOMAIN_NAME LVARCHAR(255) NOT NULL,
 	    USER_NAME VARCHAR(255) NOT NULL,
	    PRIMARY KEY (ID),
            UNIQUE(IDP_USER_ID, TENANT_ID, IDP_ID),
            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
);

CREATE TABLE IDN_USER_ACCOUNT_ASSOCIATION (
            ASSOCIATION_KEY LVARCHAR(255) NOT NULL,
            TENANT_ID INTEGER,
            DOMAIN_NAME LVARCHAR(255) NOT NULL,
            USER_NAME LVARCHAR(255) NOT NULL,
            PRIMARY KEY (TENANT_ID, DOMAIN_NAME, USER_NAME));

CREATE TABLE IF NOT EXISTS FIDO_DEVICE_STORE (
        TENANT_ID INTEGER,
        DOMAIN_NAME LVARCHAR(255) NOT NULL,
        USER_NAME LVARCHAR(45) NOT NULL,
        KEY_HANDLE LVARCHAR(200) NOT NULL,
        DEVICE_DATA LVARCHAR(2048) NOT NULL,
      PRIMARY KEY (TENANT_ID, DOMAIN_NAME, USER_NAME, KEY_HANDLE));

--CREATE OR REPLACE NETWORK RULE sharepoint_network_rules

USE ROLE OPENFLOW_ADMIN;
CREATE NETWORK RULE admin.util.sharepoint_network_rules
  MODE = EGRESS
  TYPE = HOST_PORT
  SET
  VALUE_LIST = (
    'login.microsoftonline.com:443',
    'login.microsoft.com:443',
    'graph.microsoft.com:443',
    '*.sharepoint.com:443'
  );


-- Create external access integration
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION OpenFlow_EAI
  ALLOWED_NETWORK_RULES = (
    sharepoint_network_rules
    
  )
  ENABLED = TRUE
  COMMENT = 'Openflow SPCS runtime access for SharePoint and PostgreSQL';


USE ROLE DEMO_ROLE;
LIST @RAW_DATA.SHAREPOINT_RAW.DOCUMENTS;
LIST @RAW_DATA.SHAREPOINT_RAW.DOCUMENTS ->> SELECT * FROM $1 WHERE "name" LIKE 'documents/%Budget_Optimize_Holistic_Pa_2025.xlsx';

SELECT * FROM RAW_DATA.SHAREPOINT_RAW.DOC_METADATA;
SELECT * FROM RAW_DATA.SHAREPOINT_RAW.FILE_HASHES;
SELECT * FROM RAW_DATA.SHAREPOINT_RAW.DOC_METADATA 
    WHERE 
        FILE_NAME = 'Budget_Optimize_Holistic_Pa_2025.xlsx';

SELECT 
    source, 
    CREATED_ON,
    DATEADD(hours, 2, modified_on) modified_on, 
    file_name,
    web_url
FROM 
    RAW_DATA.SHAREPOINT_RAW.DOC_METADATA 
    WHERE 
        FILE_NAME = 'Budget_Optimize_Holistic_Pa_2025.xlsx';

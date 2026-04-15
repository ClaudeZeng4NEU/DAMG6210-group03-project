USE [MovingCompanies];
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongPassword#12345';
GO

CREATE CERTIFICATE MovingCompaniesCert
WITH SUBJECT = 'Certificate for MovingCompanies column encryption';
GO

CREATE SYMMETRIC KEY MovingCompaniesSymKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE MovingCompaniesCert;
GO

ALTER TABLE CUSTOMER
ADD Email_Encrypted VARBINARY(MAX) NULL,
    Phone_Encrypted VARBINARY(MAX) NULL;
GO

ALTER TABLE CREW_MEMBER
ADD Phone_Encrypted VARBINARY(MAX) NULL;
GO

OPEN SYMMETRIC KEY MovingCompaniesSymKey
DECRYPTION BY CERTIFICATE MovingCompaniesCert;
GO

UPDATE CUSTOMER
SET
    Email_Encrypted = ENCRYPTBYKEY(KEY_GUID('MovingCompaniesSymKey'), Email),
    Phone_Encrypted = ENCRYPTBYKEY(KEY_GUID('MovingCompaniesSymKey'), Phone);

UPDATE CREW_MEMBER
SET
    Phone_Encrypted = ENCRYPTBYKEY(KEY_GUID('MovingCompaniesSymKey'), Phone);
GO

CLOSE SYMMETRIC KEY MovingCompaniesSymKey;
GO